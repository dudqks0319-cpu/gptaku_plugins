#!/usr/bin/env bash
set -euo pipefail

echo "Checking Gemini CLI..."

if ! command -v gemini >/dev/null 2>&1; then
  echo "[ERROR] gemini CLI not found." >&2
  echo "Install:" >&2
  echo "  npm install -g @google/gemini-cli" >&2
  exit 1
fi

version="$(gemini --version 2>/dev/null || true)"
if [[ -z "${version}" ]]; then
  echo "[WARN] gemini command exists but version check failed."
else
  echo "[OK] gemini version: ${version}"
fi

if command -v claude >/dev/null 2>&1; then
  echo "[INFO] claude CLI detected, but gemini-only profile can ignore it."
else
  echo "[OK] claude CLI not detected (compatible with gemini-only intent)."
fi

echo "Gemini CLI check complete."
