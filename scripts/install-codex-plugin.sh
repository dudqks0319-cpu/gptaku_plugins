#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash scripts/install-codex-plugin.sh <plugin-name>

Example:
  bash scripts/install-codex-plugin.sh pumasi
EOF
}

if [[ ${1:-} == "" ]] || [[ ${1:-} == "-h" ]] || [[ ${1:-} == "--help" ]]; then
  usage
  exit 1
fi

plugin="$1"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
gitmodules="${repo_root}/.gitmodules"
plugin_dir="${repo_root}/plugins/${plugin}"

if [[ ! -f "${gitmodules}" ]]; then
  echo "[ERROR] .gitmodules not found." >&2
  exit 1
fi

if ! grep -q "path = plugins/${plugin}" "${gitmodules}"; then
  echo "[ERROR] Unknown plugin: ${plugin}" >&2
  echo "Available plugins:" >&2
  bash "${repo_root}/scripts/list-codex-plugins.sh" >&2
  exit 1
fi

if [[ ! -d "${plugin_dir}/skills" ]]; then
  cat >&2 <<EOF
[ERROR] Skills directory not found for '${plugin}'.
Initialize the submodule first:
  git -C "${repo_root}" submodule update --init --recursive "plugins/${plugin}"
EOF
  exit 1
fi

codex_home="${CODEX_HOME:-$HOME/.codex}"
dest_root="${codex_home}/skills"
mkdir -p "${dest_root}"

installed=0
while IFS= read -r -d '' skill_path; do
  skill_name="$(basename "${skill_path}")"
  target="${dest_root}/gptaku-${plugin}-${skill_name}"

  rm -rf "${target}"
  mkdir -p "${target}"
  cp -R "${skill_path}/." "${target}/"
  installed=$((installed + 1))
  echo "[OK] installed: ${target}"
done < <(find "${plugin_dir}/skills" -mindepth 1 -maxdepth 1 -type d -print0)

if [[ ${installed} -eq 0 ]]; then
  echo "[ERROR] No skills found in ${plugin_dir}/skills" >&2
  exit 1
fi

echo ""
echo "Installed ${installed} skill(s) from plugin '${plugin}'."
echo "Target root: ${dest_root}"
echo ""
echo "Next steps:"
echo "1) Add or update AGENTS.md routing rules for installed skill names"
echo "2) Run: bash scripts/audit-codex-compat.sh ${plugin}"
