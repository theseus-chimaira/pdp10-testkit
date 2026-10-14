"""Compiler-invocation regressions requiring several compiler executions.

Unlike ordinary source-based matrix cells, these exercise combinations of
target selection, output path handling and failure diagnostics. Each check
uses a private per-cell directory; it cannot interfere with parallel cells.
"""
from pathlib import Path
import subprocess
import os
import re


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
    "output-path-dotdot": output_path_dotdot,
    "target-variants": target_variants,
}


def kl10_section0(workdir, kcc):
    (workdir / "t.c").write_text(
        "struct pair { int a; int b; };\n"
        "char *bump(char *p, int n) { return p + n; }\n"
        "double dadd(double a, double b) { return a + b; }\n"
        "struct pair copy_pair(struct pair *p) { return *p; }\n"
        "int frame(int x) { int a[6]; a[0]=x; a[5]=x+1; return a[0]+a[5]; }\n")
    status, log = _compile(kcc, workdir, "t.c", "kl10", "kl")
    if status != 0:
        return ["KL10 compile failed: " + log]
    asm = (workdir / "kl.s").read_text()
    errors = []
    for op in ("adjbp", "adjsp", "dfad", "dmove"):
        if not re.search(r"(?im)^\s*" + op + r"\s+", asm):
            errors.append("KL10 missing " + op)
    if "%ADJBPH" in asm:
        errors.append("KL10 uses unnecessary ADJBP helper")
    return errors


def local_dse(workdir, kcc):
    prefix = Path(os.environ.get("PDP10_PREFIX", "/usr/local"))
    source = Path("tests/semantic/kcc-regression/kcc_longlong_promotion_min.c")
    crt = Path("misc/kcc-regression/semantic-crt0.s")
    runner = prefix / "bin/p10run"
    errors = []
    for cpu in ("pdp6", "ka10", "ki10", "ks10"):
        directory = workdir / cpu
        directory.mkdir(exist_ok=True)
        (directory / "test.c").write_bytes(source.read_bytes())
        status, log = _compile(kcc, directory, "test.c", cpu, "dse")
        if status != 0:
            errors.append(cpu + " compile failed: " + log)
            continue
        if cpu == "pdp6":
            # The original baseline uses -x=base, not PDP-6.
            base_dir = workdir / "base"
            base_dir.mkdir(exist_ok=True)
            (base_dir / "test.c").write_bytes(source.read_bytes())
            base_status, base_log = _compile(kcc, base_dir, "test.c", "base", "dse")
            if base_status != 0:
                errors.append("base compile failed: " + base_log)
            elif re.search(r"(?im)^\s*movem\s+[0-7]+,-[456]\(17\)",
                           (base_dir / "dse.s").read_text()):
                errors.append("base: dead constant-local store survived")
        cmd = [str(runner), "--machine", cpu, "--mode", "deposit",
               "--exec-mode", "step", "--start", "1000", "--step-limit",
               "1000000", "--timeout", "10", "--workdir", str(directory / "run"),
               "--name", "dse", "--expect", "__test_exit=0",
               str(crt.resolve()), str((directory / "dse.s").resolve())]
        try:
            result = subprocess.run(cmd, cwd=str(Path.cwd()), capture_output=True,
                                    text=True, timeout=20)
            if result.returncode != 0:
                errors.append(cpu + " runtime failed: " + result.stdout + result.stderr)
        except (OSError, subprocess.TimeoutExpired) as exc:
            errors.append(cpu + " runtime exception: " + str(exc))
    return errors


CHECKS.update({
    "kl10-section0-codegen": kl10_section0,
    "local-dse": local_dse,
})


def run(name, workdir, compiler):
    if name not in CHECKS:
        return ["unknown special KCC check: " + name]
    return CHECKS[name](workdir, compiler)
