"""Compiler-invocation regressions requiring several compiler executions.

Unlike ordinary source-based matrix cells, these exercise combinations of
target selection, output path handling and failure diagnostics. Each check
uses a private per-cell directory; it cannot interfere with parallel cells.
"""
from pathlib import Path
import subprocess


def _compile(kcc, cwd, source, target, stem):
    command = [str(kcc), "-S", "-v=nostats", "-x=" + target,
               "-R=" + stem, source]
    try:
        result = subprocess.run(command, cwd=str(cwd), text=True,
                                stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                timeout=20)
        return result.returncode, result.stdout
    except subprocess.TimeoutExpired:
        return 124, "KCC compile timed out"


def output_path_dotdot(workdir, kcc):
    src = workdir / "src"
    out = workdir / "out"
    src.mkdir()
    out.mkdir()
    (src / "t.c").write_text("int main(void) { return 0; }\n")
    status, log = _compile(kcc, src, "t.c", "base", "../out/result")
    errors = []
    if status != 0:
        errors.append("KCC failed output-path compile: " + log)
    if not (out / "result.s").is_file() or (out / "result.s").stat().st_size == 0:
        errors.append("missing/empty ../out/result.s")
    if (src / ".s").exists():
        errors.append("unexpected src/.s created")
    return errors


def target_variants(workdir, kcc):
    (workdir / "macros.c").write_text(
        "#if !TARGET_ITS\n# error wrong ITS target macro\n#endif\n"
        "int variant_probe;\n")
    errors = []
    for target in ("ka10+its", "kl10+its", "ks10+its"):
        status, log = _compile(kcc, workdir, "macros.c", target,
                               "variant-" + target.replace("+", "-"))
        if status != 0:
            errors.append(target + " rejected: " + log)
    for target, diagnostic in (
            ("klx", "KL10 non-zero-section target requires MULTI_SECTION compiler build"),
            ("ki10+its", "ITS target variant requires")):
        status, log = _compile(kcc, workdir, "macros.c", target, "invalid")
        if status == 0 or status > 128 or status < 0:
            errors.append(target + " must fail without crashing")
        if diagnostic not in log:
            errors.append(target + " missing diagnostic: " + diagnostic)
    (workdir / "circ.c").write_text(
        'int f(unsigned long *pair, unsigned long *result, int count)\n'
        '{ return imuuo("CIRC", pair, result, count, 0); }\n')
    status, log = _compile(kcc, workdir, "circ.c", "ka10+its", "circ")
    if status != 0:
        errors.append("CIRC ITS compile failed: " + log)
    else:
        import re
        asm = (workdir / "circ.s").read_text()
        if not re.search(r"(?im)^\s*circ\s+[0-7]+,0\([0-7]+\)", asm):
            errors.append("CIRC instruction missing")
        if re.search(r"(?im)^\s*tdza\s+", asm):
            errors.append("CIRC incorrectly uses monitor-call skip convention")
    status, log = _compile(kcc, workdir, "circ.c", "ka10", "circ-no-its")
    if status == 0 or status > 128 or status < 0:
        errors.append("CIRC accepted without ITS or compiler crashed")
    if "CIRC requires an ITS target variant" not in log:
        errors.append("CIRC missing ITS diagnostic")
    return errors


CHECKS = {
    "output-path-dotdot-v8": output_path_dotdot,
    "target-variants": target_variants,
}


def run(name, workdir, compiler):
    if name not in CHECKS:
        return ["unknown special KCC check: " + name]
    return CHECKS[name](workdir, compiler)
