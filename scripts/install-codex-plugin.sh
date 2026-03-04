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
adapter_root="${repo_root}/profiles/gemini-only/command-adapters"

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
installed_adapters=0

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

extract_frontmatter_field() {
  local file="$1"
  local field="$2"
  awk -v key="${field}" '
    BEGIN { in_fm = 0 }
    /^---$/ {
      if (in_fm == 0) { in_fm = 1; next }
      if (in_fm == 1) { exit }
    }
    in_fm == 1 {
      if ($0 ~ "^" key ":[[:space:]]*") {
        sub("^" key ":[[:space:]]*", "", $0)
        gsub(/^"|"$/, "", $0)
        print
        exit
      }
    }
  ' "${file}"
}

build_generic_adapter() {
  local target="$1"
  local cmd_name="$2"
  local hint="$3"

  cat > "${target}" <<EOF
# Gemini Adapter (${cmd_name})

## Intent
원본 command의 기능 목표를 Codex + Gemini-only 환경에서 안전하게 수행한다.

## Input
- arguments: ${hint:-<none>}

## Rules
1. AskUserQuestion은 사용하지 않고, 필요한 경우 짧은 텍스트 질문 1개만 한다.
2. 모호하면 추천 기본값으로 즉시 진행한다.
3. 멀티에이전트 지시가 있으면 Codex agent 도구를 사용한다.
4. 외부 CLI 실행이 필요하면 gemini CLI만 사용한다.
5. claude CLI / Claude OAuth / /plugin 명령은 요구하지 않는다.

## Output
- 원본 command의 산출물 목적을 유지한다.
- 대체 동작이 있으면 명확히 고지한다.
EOF
}

create_command_shim() {
  local cmd_file="$1"
  local cmd_name
  local desc
  local arg_hint
  local target
  local adapter_src
  local adapter_target

  cmd_name="$(basename "${cmd_file}" .md)"
  desc="$(extract_frontmatter_field "${cmd_file}" "description")"
  arg_hint="$(extract_frontmatter_field "${cmd_file}" "argument-hint")"

  if [[ -z "${desc}" ]]; then
    desc="Codex shim for ${plugin}/${cmd_name}"
  fi

  target="${dest_root}/gptaku-${plugin}-command-${cmd_name}"
  rm -rf "${target}"
  mkdir -p "${target}"

  cp "${cmd_file}" "${target}/SOURCE_COMMAND.md"

  adapter_src="${adapter_root}/${plugin}/${cmd_name}.md"
  adapter_target="${target}/ADAPTER.md"

  if [[ "${gemini_only}" == true ]] && [[ -f "${adapter_src}" ]]; then
    cp "${adapter_src}" "${adapter_target}"
    installed_adapters=$((installed_adapters + 1))
  else
    build_generic_adapter "${adapter_target}" "${cmd_name}" "${arg_hint}"
  fi

  {
    cat <<EOF
---
name: gptaku-${plugin}-command-${cmd_name}
description: ${desc} (Codex shim)
---

# Codex Command Shim: /${cmd_name}

## Source Files
- `SOURCE_COMMAND.md`: 원본 command 명세
- `ADAPTER.md`: 현재 실행 프로필용 어댑터 규칙

## Mandatory Execution Order
1. `SOURCE_COMMAND.md`를 읽고 기능 의도를 파악한다.
2. `ADAPTER.md`를 읽고 실행 제약을 적용한다.
3. 원본 command의 산출물 목적은 유지하고, 도구/API 차이는 치환한다.

## Compatibility Rules
1. `AskUserQuestion` 지시는 텍스트 질문 또는 추천 기본값 자동 선택으로 치환한다.
2. `Task/subagent_type` 지시는 Codex agent 도구로 치환한다.
3. `\${CLAUDE_PLUGIN_ROOT}` 경로는 현재 설치된 skill 경로 기준으로 치환한다.
4. `/plugin ...` 명령은 사용하지 않는다.
EOF

    if [[ "${gemini_only}" == true ]]; then
      cat <<'EOF'
5. Gemini-only 프로필:
   - 외부 워커/리서치 요약 실행은 gemini CLI만 사용한다.
   - claude CLI 또는 Claude OAuth를 요구하지 않는다.
   - 외부 codex CLI 실행은 금지한다.
EOF
    fi

    cat <<'EOF'

## Output Rules
- 사용자 언어(한국어/영어)에 맞춘다.
- 원본 기능의 핵심 산출물을 유지한다.
- 치환/생략 사항이 있으면 간단히 명시한다.
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
echo "- profile adapters: ${installed_adapters}"
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
