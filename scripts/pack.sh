#!/usr/bin/env bash
# Build a linux/amd64 extension release archive + SHA256SUMS from this repo root.
# Usage: bash scripts/pack.sh [out-dir]
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

OUT_DIR="${1:-dist}"
mkdir -p "${OUT_DIR}"

if [[ ! -f fleet.ext.yaml ]]; then
  echo "missing fleet.ext.yaml in ${ROOT}" >&2
  exit 2
fi

EXT_ID="$(python3 - <<'PY'
import re
from pathlib import Path
text = Path("fleet.ext.yaml").read_text()
m = re.search(r"(?m)^id:\s*[\"']?([^\"'\s#]+)", text)
if not m:
    raise SystemExit("fleet.ext.yaml: missing id")
print(m.group(1).strip())
PY
)"
if [[ -z "${EXT_ID}" ]]; then
  echo "could not read id from fleet.ext.yaml" >&2
  exit 2
fi

# Archive top-level folder = last id segment (e.g. org.example.template → template)
SLUG="${EXT_ID##*.}"
ASSET="${EXT_ID}-linux-amd64.tar.gz"

echo "Building worker…"
make build

STAGE="$(mktemp -d)"
trap 'rm -rf "${STAGE}"' EXIT
DEST="${STAGE}/${SLUG}"
mkdir -p "${DEST}"

cp -a fleet.ext.yaml "${DEST}/"
if [[ -d ui ]]; then
  cp -a ui "${DEST}/"
fi
if [[ -d bin ]] && compgen -G "bin/*" >/dev/null; then
  mkdir -p "${DEST}/bin"
  cp -a bin/* "${DEST}/bin/"
  chmod +x "${DEST}/bin/"* || true
fi
if [[ -f LICENSE ]]; then
  cp -a LICENSE "${DEST}/LICENSE"
fi

tar -C "${STAGE}" -czf "${OUT_DIR}/${ASSET}" "${SLUG}"
(
  cd "${OUT_DIR}"
  sha256sum "${ASSET}" | tee SHA256SUMS
)
echo "Wrote ${OUT_DIR}/${ASSET}"
