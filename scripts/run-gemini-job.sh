#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash scripts/run-gemini-job.sh <prompt-file> [output-file]

Examples:
  bash scripts/run-gemini-job.sh /tmp/prompt.md
  bash scripts/run-gemini-job.sh /tmp/prompt.md /tmp/result.txt
EOF
}

if [[ ${1:-} == "" ]] || [[ ${1:-} == "-h" ]] || [[ ${1:-} == "--help" ]]; then
  usage
  exit 1
fi

prompt_file="$1"
output_file="${2:-}"

if [[ ! -f "${prompt_file}" ]]; then
  echo "[ERROR] Prompt file not found: ${prompt_file}" >&2
  exit 1
fi

if ! command -v gemini >/dev/null 2>&1; then
  echo "[ERROR] gemini CLI not found. Install: npm install -g @google/gemini-cli" >&2
  exit 1
fi

if [[ -z "${output_file}" ]]; then
  output_file="/tmp/gemini-job-$(date +%Y%m%d-%H%M%S).txt"
fi

gemini --yolo -m gemini-2.5-pro "${prompt_file}" > "${output_file}"

echo "[OK] Gemini output saved: ${output_file}"
