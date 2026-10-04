PDP10_PREFIX ?=
JOBS ?= 1
DAS_ROOT ?= ../das
PDP10_TOOLS_REPO = ../pdp10-tools
PDP10_TOOLS_BIN = $(PDP10_PREFIX)/bin


.PHONY: all check-prefix verify list list-kcc list-gcc test test-parallel test-das-fast test-das test-das-native test-gcc-bare-libgcc test-daimos-type340-text reset clean check-kcc-regression check-kcc-semantic check-kcc-all

check-prefix:
	@test -n "$(PDP10_PREFIX)" || { echo "PDP10_PREFIX must be set" >&2; exit 2; }

all: check-prefix verify

verify: check-prefix
	@PDP10_PREFIX="$(PDP10_PREFIX)" python3 tools/verify-testkit-layout.py
	@PDP10_PREFIX="$(PDP10_PREFIX)" python3 tools/verify-optimization-common-source.py
	@PDP10_PREFIX="$(PDP10_PREFIX)" python3 tools/check-gcc-symbol-length.py
	@PDP10_PREFIX="$(PDP10_PREFIX)" python3 tools/test-stubselect.py
	@PDP10_PREFIX="$(PDP10_PREFIX)" python3 tools/verify-type-semantics.py
	@PDP10_PREFIX="$(PDP10_PREFIX)" python3 tools/verify-wide-int-adapters.py
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-int71-header.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-wide-int-modes.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-wide-call-abi.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-wide-varargs-abi.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-wide-data-layout.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-pointer-abi.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-aggregate-return-abi.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-extended-aggregate-abi.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-layout-float-abi.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-symbol-runtime-abi-v11.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-mixed-fixed-exec-v12.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-mixed-call-depth-v24.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-small-aggregate-arg-abi-v25.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-gcc-cross-word-bitfield-v26.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-kcc-gcc-cross-word-bitfield-v27.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-kcc-gcc-aggregate-stack-v28.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-kcc-gcc-nested-union-v29.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-kcc-gcc-varargs-matrix-v30.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-kcc-gcc-layout-edge-v31.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-kcc-gcc-negative-dimode-v32.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-gcc-dimode-divmod-v33.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-kcc-gcc-runtime-helper-v34.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-kcc-gcc-reloc-v35.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-kcc-gcc-direct-abi-v36.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-kcc-gcc-object-symbol-v37.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-kcc-gcc-representation-adapter-v38.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-gcc-scalar-move-order-v39.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/validation/gcc/byteptr2/test-no-xkl2-byte-extend-v40.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-gcc-callee-save-pushpop-v41.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-language-compat-v13.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-language-promotions-v14.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-language-casts-v15.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-language-conversions-v17.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-language-full-range-v18.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-language-direct-widening-v19.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-language-char-enum-v20.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-packed-char-v21.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-packed-bitptr-v22.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" sh tests/compat/test-packed-bitptr-arith-v23.sh
list: check-prefix
	@PDP10_PREFIX="$(PDP10_PREFIX)" ./run-tests.sh --list-only --compiler all --family all --cpu all --opt all

list-kcc: check-prefix
	@PDP10_PREFIX="$(PDP10_PREFIX)" ./run-tests.sh --list-only --compiler kcc --family all --cpu all --opt all

list-gcc: check-prefix
	@PDP10_PREFIX="$(PDP10_PREFIX)" ./run-tests.sh --list-only --compiler gcc --family all --cpu all --opt all

test: check-prefix
	@PDP10_PREFIX="$(PDP10_PREFIX)" ./run-tests.sh -j "$(JOBS)" --compiler all --family all --cpu all --opt all

test-parallel: check-prefix
	@PDP10_PREFIX="$(PDP10_PREFIX)" ./run-tests.sh -j "$(JOBS)" --compiler all --family all --cpu all --opt all

test-das-fast: check-prefix
	@test -f "$(DAS_ROOT)/das.c" || { echo "invalid DAS_ROOT: $(DAS_ROOT)" >&2; exit 1; }
	@$(MAKE) -C "$(DAS_ROOT)" PDP10_PREFIX="$(PDP10_PREFIX)" all
	@PDP10_PREFIX="$(PDP10_PREFIX)" DAS_ROOT="$$(cd "$(DAS_ROOT)" && pwd -P)" tests/das/run-das-fast-tests.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" DAS_ROOT="$$(cd "$(DAS_ROOT)" && pwd -P)" tests/das/check-das-phase-ir-v1.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" DAS_ROOT="$$(cd "$(DAS_ROOT)" && pwd -P)" tests/das/check-das-phase2-transport-v1.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" DAS_ROOT="$$(cd "$(DAS_ROOT)" && pwd -P)" tests/das/check-reloc-negative-addend-v1.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" DAS_ROOT="$$(cd "$(DAS_ROOT)" && pwd -P)" tests/das/check-symbol-leading-data-v1.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" DAS_ROOT="$$(cd "$(DAS_ROOT)" && pwd -P)" tests/das/check-s6filter.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" DAS_ROOT="$$(cd "$(DAS_ROOT)" && pwd -P)" tests/das/run-das-stream-tests.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" DAS_ROOT="$$(cd "$(DAS_ROOT)" && pwd -P)" sh tests/das/check-s6text.sh


test-das: test-das-fast
	@PDP10_PREFIX="$(PDP10_PREFIX)" DAS_ROOT="$$(cd "$(DAS_ROOT)" && pwd -P)" tests/das/run-das-tests.sh
	@PDP10_PREFIX="$(PDP10_PREFIX)" DAS_ROOT="$$(cd "$(DAS_ROOT)" && pwd -P)" sh tests/das/run-dobj-link-tests.sh


test-das-native: check-prefix
	@test -f "$(DAS_ROOT)/das.c" || { echo "invalid DAS_ROOT: $(DAS_ROOT)" >&2; exit 1; }
	@PDP10_PREFIX="$(PDP10_PREFIX)" DAS_ROOT="$$(cd "$(DAS_ROOT)" && pwd -P)" DAIMOS_REPO="$(DAIMOS_REPO)" \
		tests/das/build-das-native-phases-v1.sh

test-gcc-bare-libgcc: check-prefix
	@PDP10_PREFIX="$(PDP10_PREFIX)" tests/validation/gcc/bare-runtime/test-badl-tables-v1.sh

test-daimos-type340-text:
	@test -n "$(TMPDIR)" || { echo "TMPDIR must be set" >&2; exit 2; }
	@TMPDIR="$(TMPDIR)" DAIMOS_REPO="$${DAIMOS_REPO:-../DAIMOS}" \
		tests/daimos/run-type340-text-v1.sh


test-pdp10-tools: check-prefix
	@test -f "$(PDP10_TOOLS_REPO)/Makefile" || { echo "invalid PDP10_TOOLS_REPO: $(PDP10_TOOLS_REPO)" >&2; exit 1; }
	@test -n "$(TMPDIR)" || { echo "TMPDIR must be set" >&2; exit 2; }
	@PDP10_PREFIX="$(PDP10_PREFIX)" TMPDIR="$(TMPDIR)" \
		PDP10_TOOLS_REPO="$$(cd "$(PDP10_TOOLS_REPO)" && pwd -P)" \
		tests/pdp10-tools/run.sh

reset: check-prefix
	@PDP10_PREFIX="$(PDP10_PREFIX)" ./run-tests.sh --reset --compiler all --family all --cpu all --opt all

clean:
	rm -rf workdir __pycache__ tools/__pycache__ tests/das/__pycache__
	find . -name '*~' -o -name '*.pyc' | xargs -r rm -f

check-kcc-regression: check-prefix
	PDP10_PREFIX="$(PDP10_PREFIX)" sh ./run-kcc-regressions.sh fast

check-kcc-semantic: check-prefix
	PDP10_PREFIX="$(PDP10_PREFIX)" sh ./run-kcc-regressions.sh semantic

check-kcc-all: check-prefix
	PDP10_PREFIX="$(PDP10_PREFIX)" sh ./run-kcc-regressions.sh all

.PHONY: check-kcc-regression check-kcc-semantic check-kcc-all
