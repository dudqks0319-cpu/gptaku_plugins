#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
gitmodules="${repo_root}/.gitmodules"

if [[ ! -f "${gitmodules}" ]]; then
  echo "[ERROR] .gitmodules not found: ${gitmodules}" >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "[ERROR] git is required." >&2
  exit 1
fi

git -C "${repo_root}" config -f .gitmodules --get-regexp '^submodule\..*\.path$' \
  | awk '{print $2}' \
  | sed 's#^plugins/##' \
  | sort -u
