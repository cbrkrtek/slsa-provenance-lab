#!/usr/bin/env bash
set -euo pipefail

IMAGE_REF="${1:?Execution: ./verify.sh <image_name:tag_or_sha> [log_filename] [provenance_path]}"
LOG_NAME="${2:-slsa-verification.log}"
PROVENANCE_PATH="${3:-}"

export GH_TOKEN="${GH_TOKEN:-$(gh auth token 2>/dev/null || true)}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOG_PATH="${REPO_DIR}/evidence/logs/${LOG_NAME}"

echo "Receiving digest for ${IMAGE_REF}..."
DIGEST=$(crane digest "${IMAGE_REF}")
IMAGE_REPO="${IMAGE_REF%%:*}"


EXTRA_FLAGS=()
if [ -n "${PROVENANCE_PATH}" ]; then
    EXTRA_FLAGS+=(--provenance-path "${PROVENANCE_PATH}")
fi

echo "Check SLSA Provenance for ${IMAGE_REPO}@${DIGEST}..."

set +e
slsa-verifier verify-image "${IMAGE_REPO}@${DIGEST}" \
  --source-uri github.com/cbrkrtek/slsa-provenance-lab \
  --source-branch main \
  "${EXTRA_FLAGS[@]}" 2>&1 | tee "${LOG_PATH}"

EXIT_CODE=${PIPESTATUS[0]}
set -e

if [ $EXIT_CODE -eq 0 ]; then
    echo "Result: Image is legitimate (SLSA PASSED)"
else
    echo "Result: Image isn't legitimate (SLSA FAILED)"
fi

exit $EXIT_CODE
