#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash scripts/install-all-codex-plugins.sh [--gemini-only]

Examples:
  bash scripts/install-all-codex-plugins.sh
  bash scripts/install-all-codex-plugins.sh --gemini-only
EOF
}

gemini_only=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --gemini-only)
      gemini_only=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[ERROR] Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
  shift
done

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v git >/dev/null 2>&1; then
  echo "[ERROR] git is required." >&2
  exit 1
fi

if [[ ! -f "${repo_root}/.gitmodules" ]]; then
  echo "[ERROR] .gitmodules not found in ${repo_root}" >&2
  exit 1
fi

plugins=()
while IFS= read -r p; do
  [[ -n "${p}" ]] && plugins+=("${p}")
done < <(bash "${repo_root}/scripts/list-codex-plugins.sh")

if [[ ${#plugins[@]} -eq 0 ]]; then
  echo "[ERROR] No plugins found in .gitmodules" >&2
  exit 1
fi

echo "Installing ${#plugins[@]} plugin(s)..."
if [[ "${gemini_only}" == true ]]; then
  echo "Profile: gemini-only"
else
  echo "Profile: default"
fi

echo ""

for plugin in "${plugins[@]}"; do
  echo "==> ${plugin}"
  git -C "${repo_root}" submodule update --init --recursive "plugins/${plugin}"

  if [[ "${gemini_only}" == true ]]; then
    bash "${repo_root}/scripts/install-codex-plugin.sh" "${plugin}" --gemini-only
  else
    bash "${repo_root}/scripts/install-codex-plugin.sh" "${plugin}"
  fi

  echo ""
done

echo "All plugins installed."
