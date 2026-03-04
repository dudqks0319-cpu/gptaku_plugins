#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash scripts/install-all-codex-plugins.sh [--profile <name>]

Profiles:
  codex53xhigh-ui-gemini (default)
  gemini-only

Shorthands:
  --ui-gemini   => --profile codex53xhigh-ui-gemini
  --gemini-only => --profile gemini-only

Examples:
  bash scripts/install-all-codex-plugins.sh
  bash scripts/install-all-codex-plugins.sh --ui-gemini
  bash scripts/install-all-codex-plugins.sh --profile gemini-only
EOF
}

profile="codex53xhigh-ui-gemini"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile)
      shift
      if [[ -z "${1:-}" ]]; then
        echo "[ERROR] --profile requires a value" >&2
        usage
        exit 1
      fi
      profile="$1"
      ;;
    --ui-gemini)
      profile="codex53xhigh-ui-gemini"
      ;;
    --gemini-only)
      profile="gemini-only"
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

if [[ "${profile}" != "codex53xhigh-ui-gemini" ]] && [[ "${profile}" != "gemini-only" ]]; then
  echo "[ERROR] Unsupported profile: ${profile}" >&2
  exit 1
fi

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
echo "Profile: ${profile}"
echo ""

for plugin in "${plugins[@]}"; do
  echo "==> ${plugin}"
  git -C "${repo_root}" submodule update --init --recursive "plugins/${plugin}"
  bash "${repo_root}/scripts/install-codex-plugin.sh" "${plugin}" --profile "${profile}"
  echo ""
done

echo "All plugins installed."
