# Gemini-Only Profile

기준일: 2026-03-04

## 목적

Claude OAuth를 사용할 수 없는 환경에서, GPTaku 원본 기능을 최대한 유지하면서 실행 경로를 Gemini CLI 중심으로 고정한다.

## 적용 방식

`--gemini-only` 옵션으로 설치하면:

1. 원본 `skills/*`를 그대로 설치
2. 원본 `commands/*.md`마다 Codex command shim 생성
3. shim 실행 규칙에 아래를 강제
   - 외부 실행자: Gemini CLI만 허용
   - Claude OAuth/Claude CLI 요구 금지
   - Codex CLI 외부 워커 호출 금지

## 설치

전체 설치:

```bash
bash scripts/install-all-codex-plugins.sh --gemini-only
```

개별 설치:

```bash
bash scripts/install-codex-plugin.sh <plugin-name> --gemini-only
```

## 한계

- 원본의 `AskUserQuestion`, `Task`, `TeamCreate`는 Codex 환경에서 1:1 API가 아니므로 shim 어댑트가 필요
- 따라서 UI/인터랙션 흐름은 일부 달라질 수 있음
- 기능 목표(산출물/워크플로우)는 유지하되, 실행 메커니즘은 Codex+Gemini 규칙으로 치환됨

## 운영 권장

1. 먼저 `bash scripts/check-gemini-cli.sh`로 실행 환경 검증
2. 설치 후 `bash scripts/audit-codex-compat.sh`로 Claude 전용 패턴 잔존 파악
3. 자주 쓰는 command shim부터 실제 워크플로우 테스트 후 세부 튜닝
