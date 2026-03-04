# GPTaku Codex Plugins

`fivetaku/gptaku_plugins`를 Codex 환경에서 재사용할 수 있도록 정리한 포크입니다.

현재 이 포크는 **원본 기능 전체를 가져오되, 실행 프로필은 Gemini CLI only**를 지원합니다.

- 원본 plugin의 `skills/*` 자산 설치
- 원본 `commands/*.md`를 Codex용 command shim skill로 자동 생성
- command별 Gemini 어댑터(8/8) 자동 포함
- Claude OAuth/Claude CLI 의존 없이 Gemini CLI 기준으로 실행 규칙 고정 가능

원본 저장소: <https://github.com/fivetaku/gptaku_plugins>

## Quick Start (Gemini Only)

1. 저장소 클론 + 서브모듈 초기화

```bash
git clone --recurse-submodules https://github.com/dudqks0319-cpu/gptaku_plugins.git
cd gptaku_plugins
```

2. Gemini CLI 점검

```bash
bash scripts/check-gemini-cli.sh
```

3. 원본 기능 전체 설치 (Gemini 전용 프로필)

```bash
bash scripts/install-all-codex-plugins.sh --gemini-only
```

설치 위치:
- `${CODEX_HOME:-$HOME/.codex}/skills`

생성되는 항목:
- `gptaku-<plugin>-<skill>`: 원본 skill 복사본
- `gptaku-<plugin>-command-<command>`: Codex command shim (+ ADAPTER.md)

## 단일 플러그인 설치

```bash
bash scripts/install-codex-plugin.sh <plugin-name> --gemini-only
```

예시:

```bash
bash scripts/install-codex-plugin.sh kkirikkiri --gemini-only
```

## 8개 샘플 자동 생성

```bash
bash scripts/generate-gemini-command-samples.sh
```

생성 경로:
- `examples/gemini-only/*.md`

## 호환성 점검

원본 플러그인의 Claude 전용 패턴 잔존 여부 확인:

```bash
bash scripts/audit-codex-compat.sh
```

특정 플러그인만:

```bash
bash scripts/audit-codex-compat.sh deep-research
```

## Gemini 실행 유틸리티

```bash
bash scripts/run-gemini-job.sh <prompt-file> [output-file]
```

## 문서

- Gemini 프로필: [docs/gemini-only-profile.md](docs/gemini-only-profile.md)
- 마이그레이션 분석: [docs/codex-migration-analysis.md](docs/codex-migration-analysis.md)
- 어댑터 커버리지: [docs/adapter-coverage.md](docs/adapter-coverage.md)

## Gemini-Only 주의사항

- 이 프로필은 Claude OAuth 불가 환경을 전제로 함
- 일부 원본 워크플로우(`AskUserQuestion`, `Task`)는 Codex 방식으로 어댑트되므로 1:1 UI 동작은 다를 수 있음
- 기능 목표(산출물/흐름)는 유지하고 실행 메커니즘만 치환함

## License

원본과 동일하게 MIT를 따릅니다.
