# GPTaku Codex Plugins

`fivetaku/gptaku_plugins`를 Codex 환경에서 재사용할 수 있도록 정리한 포크입니다.

기본 실행 기준은 아래와 같습니다.
- **UI/UX/디자인 작업만 Gemini CLI**
- **그 외 모든 작업은 Codex 5.3 xhigh**

## Quick Start

1. 저장소 클론 + 서브모듈 초기화

```bash
git clone --recurse-submodules https://github.com/dudqks0319-cpu/gptaku_plugins.git
cd gptaku_plugins
```

2. 런타임 점검

```bash
bash scripts/check-runtime-profile.sh codex53xhigh-ui-gemini
```

3. 원본 기능 전체 설치 (기본 프로필)

```bash
bash scripts/install-all-codex-plugins.sh
```

`install-all-codex-plugins.sh`의 기본 프로필은 `codex53xhigh-ui-gemini` 입니다.

설치 위치:
- `${CODEX_HOME:-$HOME/.codex}/skills`

생성 항목:
- `gptaku-<plugin>-<skill>`: 원본 skill 복사본
- `gptaku-<plugin>-command-<command>`: command shim (`SOURCE_COMMAND.md` + `ADAPTER.md`)

## 프로필 선택

명시적으로 지정하려면:

```bash
bash scripts/install-all-codex-plugins.sh --profile codex53xhigh-ui-gemini
```

Legacy(gemini-only):

```bash
bash scripts/install-all-codex-plugins.sh --profile gemini-only
```

## 단일 플러그인 설치

```bash
bash scripts/install-codex-plugin.sh <plugin-name> --profile codex53xhigh-ui-gemini
```

## 샘플 생성

```bash
bash scripts/generate-codex53xhigh-ui-gemini-samples.sh
```

생성 경로:
- `examples/codex53xhigh-ui-gemini/*.md`

## 호환성 점검

```bash
bash scripts/audit-codex-compat.sh
```

특정 플러그인만:

```bash
bash scripts/audit-codex-compat.sh deep-research
```

## 문서

- 프로필 문서: [docs/codex53xhigh-ui-gemini-profile.md](docs/codex53xhigh-ui-gemini-profile.md)
- 어댑터 커버리지: [docs/adapter-coverage.md](docs/adapter-coverage.md)
- 마이그레이션 분석: [docs/codex-migration-analysis.md](docs/codex-migration-analysis.md)
- Gemini-only(legacy): [docs/gemini-only-profile.md](docs/gemini-only-profile.md)

## 주의사항

- 원본의 Claude 전용 인터랙션(`AskUserQuestion`, `Task`)은 Codex 실행 방식으로 치환됩니다.
- 기능 목표(산출물/흐름)는 유지하고, 실행 메커니즘만 프로필 규칙에 맞춰 변환합니다.

## License

원본과 동일하게 MIT를 따릅니다.
