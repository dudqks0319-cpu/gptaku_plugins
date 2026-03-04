#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
plugins_root="${repo_root}/plugins"

if [[ ! -d "${plugins_root}" ]]; then
  echo "[ERROR] plugins directory not found: ${plugins_root}" >&2
  exit 1
fi

target="${1:-all}"

echo "Codex compatibility audit"
echo "- repo: ${repo_root}"
echo "- target: ${target}"
echo ""
printf "%-20s | %-6s | %-6s | %-6s | %-6s\n" "plugin" "askq" "croot" "task" "pcmd"
printf "%-20s-+-%-6s-+-%-6s-+-%-6s-+-%-6s\n" "--------------------" "------" "------" "------" "------"

scan_one() {
  local plugin_dir="$1"
  local name
  local askq=0
  local croot=0
  local task=0
  local pcmd=0

  name="$(basename "${plugin_dir}")"

  if [[ ! -d "${plugin_dir}" ]]; then
    return
  fi

  askq=$(grep -RIl "AskUserQuestion" "${plugin_dir}" 2>/dev/null | wc -l | tr -d ' ')
  croot=$(grep -RIl '\${CLAUDE_PLUGIN_ROOT}' "${plugin_dir}" 2>/dev/null | wc -l | tr -d ' ')
  task=$(grep -RIl "Task tool\|subagent_type\|run_in_background" "${plugin_dir}" 2>/dev/null | wc -l | tr -d ' ')
  pcmd=$(grep -RIl "/plugin " "${plugin_dir}" 2>/dev/null | wc -l | tr -d ' ')

  printf "%-20s | %-6s | %-6s | %-6s | %-6s\n" "${name}" "${askq}" "${croot}" "${task}" "${pcmd}"
}

if [[ "${target}" == "all" ]]; then
  while IFS= read -r -d '' dir; do
    scan_one "${dir}"
  done < <(find "${plugins_root}" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
else
  scan_one "${plugins_root}/${target}"
fi

echo ""
echo "Legend:"
echo "- askq: AskUserQuestion references"
echo "- croot: \${CLAUDE_PLUGIN_ROOT} references"
echo "- task: Task-tool oriented orchestration references"
echo "- pcmd: /plugin command references"
