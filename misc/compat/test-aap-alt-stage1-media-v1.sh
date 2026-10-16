#!/bin/sh
# Prepare BOTH authentic alternative DAIMOS Stage-1 boot paths for AAP.
# The optional test below proves Stage-1 execution only, NOT kernel boot.
set -eu
export TMPDIR=${TMPDIR:-$HOME/tmp}
root=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
out=${AAP_ALT_BOOT_OUT:-$TMPDIR/aap-alt-stage1-media-v1}
image=${DAIMOS_COMPRESSED_WORDS:-$root/DAIMOS/build/system/boot/pdp6/kinit.d6lz.words}
das_bin=${DAS:-$root/das/das}
converter=${DXRCONVERT:-$root/das/dxrconvert}
words2pt=${WORDS2PT:-$root/daimos-tools/words2pt}
mkdt=${MKDT:-$root/daimos-tools/mkdt}
for executable in "$das_bin" "$converter" "$words2pt" "$mkdt"; do
  test -x "$executable" || { echo "Missing tool: $executable" >&2; exit 1; }
done
test -s "$image" || { echo "Missing compressed KINIT image: $image" >&2; exit 1; }
mkdir -p "$out"
for mode in ptr dtc; do
  "$das_bin" -F -K -O "$out/stage1-$mode-v1.dxr" "$root/DAIMOS/system/stand/pdp6/$mode/stage1.s"
  "$converter" --pdp6-readin -b 060 "$out/stage1-$mode-v1.dxr" "$out/stage1-$mode-v1.pt"
  printf '\252' >> "$out/stage1-$mode-v1.pt"
done
cwords=$(($(wc -l < "$image") - 3))
first=$(((cwords+1)/2))
second=$((cwords-first))
test "$first" -gt 0 && test "$second" -gt 0
{ printf '%012o\n' $((first+3)); head -n 3 "$image"; tail -n +4 "$image" | head -n "$first"; } > "$out/ptr-boot1-v1.words"
{ printf '%012o\n' "$second"; tail -n +4 "$image" | tail -n "$second"; } > "$out/ptr-boot2-v1.words"
"$words2pt" -t ptr -p "$out/ptr-boot1-v1.words" -o "$out/ptr-boot1-v1.pt"
"$words2pt" -t ptr -p "$out/ptr-boot2-v1.words" -o "$out/ptr-boot2-v1.pt"
"$mkdt" -t dtc -p "$image" -o "$out/dtc0-v1.tap"
for f in stage1-ptr-v1.pt stage1-dtc-v1.pt ptr-boot1-v1.pt ptr-boot2-v1.pt dtc0-v1.tap; do test -s "$out/$f"; done
printf 'AAP dual Stage-1 media prepared: %s\n' "$out"
printf 'Paper tape: Stage-1 + payload tapes 1 and 2 (operator must swap)\n'
printf 'DECtape: Stage-1 PTR read-in + Type-136/551/555 stream (format compatibility not yet verified)\n'
printf 'No KINIT/KCORE/MRES runtime execution has been claimed.\n'
