#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash scripts/install-codex-plugin.sh <plugin-name> [--gemini-only]

Examples:
  bash scripts/install-codex-plugin.sh pumasi
  bash scripts/install-codex-plugin.sh kkirikkiri --gemini-only
EOF
}

plugin=""
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
    -*)
      echo "[ERROR] Unknown option: $1" >&2
      usage
      exit 1
      ;;
    *)
      if [[ -n "${plugin}" ]]; then
        echo "[ERROR] Multiple plugin names provided: '${plugin}', '$1'" >&2
        usage
        exit 1
      fi
      plugin="$1"
      ;;
  esac
  shift
done

if [[ -z "${plugin}" ]]; then
  usage
  exit 1
fi

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

if [[ ! -d "${plugin_dir}" ]]; then
  cat >&2 <<EOF
[ERROR] Plugin directory not found for '${plugin}'.
Initialize the submodule first:
  git -C "${repo_root}" submodule update --init --recursive "plugins/${plugin}"
EOF
  exit 1
fi

codex_home="${CODEX_HOME:-$HOME/.codex}"
dest_root="${codex_home}/skills"
mkdir -p "${dest_root}"

installed_skills=0
installed_shims=0

install_skill_dirs() {
  local src_skills_dir="$1"
  if [[ ! -d "${src_skills_dir}" ]]; then
    return
  fi

  while IFS= read -r -d '' skill_path; do
    local skill_name
    local target

    skill_name="$(basename "${skill_path}")"
    target="${dest_root}/gptaku-${plugin}-${skill_name}"

    rm -rf "${target}"
    mkdir -p "${target}"
    cp -R "${skill_path}/." "${target}/"

    installed_skills=$((installed_skills + 1))
    echo "[OK] installed skill: ${target}"
  done < <(find "${src_skills_dir}" -mindepth 1 -maxdepth 1 -type d -print0)
}

extract_description() {
  local file="$1"
  awk '
    /^description:/ {
      sub(/^description:[[:space:]]*/, "", $0)
      gsub(/^"|"$/, "", $0)
      print
      exit
    }
  ' "${file}"
}

create_command_shim() {
  local cmd_file="$1"
  local cmd_name
  local desc
  local target

  cmd_name="$(basename "${cmd_file}" .md)"
  desc="$(extract_description "${cmd_file}")"
  if [[ -z "${desc}" ]]; then
    desc="Codex shim for ${plugin}/${cmd_name}"
  fi

  target="${dest_root}/gptaku-${plugin}-command-${cmd_name}"
  rm -rf "${target}"
  mkdir -p "${target}"

  cp "${cmd_file}" "${target}/SOURCE_COMMAND.md"

  {
    cat <<EOF
---
name: gptaku-${plugin}-command-${cmd_name}
description: ${desc} (Codex shim)
---

# Codex Command Shim: /${cmd_name}

이 스킬은 원본 GPTaku command를 Codex 환경에서 실행하기 위한 호환 레이어입니다.

## Source
- 원본 command 명세: `SOURCE_COMMAND.md`
- 원본 plugin 자산: `${dest_root}/gptaku-${plugin}-*`

## Execution Rules
1. `SOURCE_COMMAND.md`의 의도와 출력 형식을 최대한 유지한다.
2. `AskUserQuestion` 의존 단계는 다음으로 치환한다:
   - 꼭 필요할 때만 짧은 질문 1개를 텍스트로 묻기
   - 안전한 경우 추천 기본값으로 자동 진행
3. `Task`/`subagent_type` 기반 지시는 Codex agent 도구(`spawn_agent`, `send_input`, `wait`)로 치환한다.
4. `\${CLAUDE_PLUGIN_ROOT}` 경로 참조는 현재 설치된 skill 경로 기준으로 해석한다.
5. `/plugin ...` 명령을 요구하지 않는다.
EOF

    if [[ "${gemini_only}" == true ]]; then
      cat <<'EOF'
6. Gemini-only 프로필:
   - 외부 실행자는 `gemini` CLI만 사용한다.
   - `claude` CLI 또는 Claude OAuth를 요구하지 않는다.
   - 외부 워커로 `codex` CLI를 호출하지 않는다.
EOF
    fi

    cat <<'EOF'

## Output Rules
- 사용자의 언어(한국어/영어)에 맞춘다.
- 원본 기능의 핵심 산출물을 유지한다.
- 호환성 한계가 있으면 대체 동작을 명시한다.
EOF
  } > "${target}/SKILL.md"

  installed_shims=$((installed_shims + 1))
  echo "[OK] installed command shim: ${target}"
}

install_skill_dirs "${plugin_dir}/skills"

if [[ -d "${plugin_dir}/commands" ]]; then
  while IFS= read -r -d '' cmd_file; do
    create_command_shim "${cmd_file}"
  done < <(find "${plugin_dir}/commands" -mindepth 1 -maxdepth 1 -type f -name '*.md' -print0)
fi

if [[ ${installed_skills} -eq 0 ]] && [[ ${installed_shims} -eq 0 ]]; then
  echo "[ERROR] Nothing installable found in ${plugin_dir} (skills/commands missing)." >&2
  exit 1
fi

echo ""
echo "Installed plugin: ${plugin}"
echo "- skill dirs: ${installed_skills}"
echo "- command shims: ${installed_shims}"
echo "- target root: ${dest_root}"
if [[ "${gemini_only}" == true ]]; then
  echo "- profile: gemini-only"
else
  echo "- profile: default"
fi

echo ""
echo "Next steps:"
echo "1) Run: bash scripts/audit-codex-compat.sh ${plugin}"
echo "2) Ensure AGENTS.md routes trigger names to installed skills"
