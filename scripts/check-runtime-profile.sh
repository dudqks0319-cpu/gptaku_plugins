#!/usr/bin/env bash
set -euo pipefail

profile="${1:-codex53xhigh-ui-gemini}"

if [[ "${profile}" != "codex53xhigh-ui-gemini" ]] && [[ "${profile}" != "gemini-only" ]]; then
  echo "[ERROR] Unsupported profile: ${profile}" >&2
  exit 1
fi

echo "Checking runtime profile: ${profile}"

if ! command -v codex >/dev/null 2>&1; then
  echo "[ERROR] codex CLI not found." >&2
  echo "Install: npm install -g @openai/codex" >&2
  exit 1
fi

echo "[OK] codex CLI: $(codex --version 2>/dev/null || echo 'version unknown')"

default_model="${CODEX_MODEL:-codex-5.3}"
default_reasoning="${CODEX_REASONING:-xhigh}"
echo "[INFO] codex default model: ${default_model}"
echo "[INFO] codex default reasoning: ${default_reasoning}"

if ! command -v gemini >/dev/null 2>&1; then
  if [[ "${profile}" == "gemini-only" ]]; then
    echo "[ERROR] gemini CLI is required for gemini-only profile." >&2
    echo "Install: npm install -g @google/gemini-cli" >&2
    exit 1
  fi

  echo "[WARN] gemini CLI not found."
  echo "[WARN] UI/UX tasks cannot be routed to Gemini until installed."
  exit 0
fi

echo "[OK] gemini CLI: $(gemini --version 2>/dev/null || echo 'version unknown')"

echo "Runtime profile check complete."
