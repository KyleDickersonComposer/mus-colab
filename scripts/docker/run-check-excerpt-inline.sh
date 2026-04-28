#!/usr/bin/env bash
# Parallel lilypond on chapters/*/excerpt/*.ly and */inline/*.ly (same first stage as make pdf).

set -euo pipefail
cd /workdir

: "${OUTPUT_DIR:=bin}"
: "${LILYPOND_CHECK_JOBS:=8}"
export LILYPOND_FLAGS="${LILYPOND_FLAGS:--dwarning-as-error}"
export OUTPUT_DIR

mkdir -p "${OUTPUT_DIR}/lycheck"
echo ""
echo "================ check-ly (excerpt/inline .ly, parallel) ================"
echo "(LILYPOND_CHECK_JOBS=${LILYPOND_CHECK_JOBS}; override: make LILYPOND_CHECK_JOBS=N pdf|check-ly)"
if ! find chapters -type f \( -path "*/excerpt/*.ly" -o -path "*/inline/*.ly" \) | grep -q .; then
	echo "check-ly: no excerpt/inline .ly files found; skipping."
	exit 0
fi
# shellcheck disable=SC2086
find chapters -type f \( -path "*/excerpt/*.ly" -o -path "*/inline/*.ly" \) -print0 |
	xargs -r -0 -P"${LILYPOND_CHECK_JOBS}" -n1 bash -c '
		f="$1"
		echo ""
		echo "==== lilypond ${f} ===="
		b="$(basename "$f" .ly)"
		exec lilypond ${LILYPOND_FLAGS} \
			-I/workdir -I/workdir/source -I/workdir/source/lilyjazz-styles \
			-o "/workdir/${OUTPUT_DIR}/lycheck/${b}" "/workdir/${f}"
	' bash

echo ""
echo "check-ly: all excerpt/inline .ly files OK."
