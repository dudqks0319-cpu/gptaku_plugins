# GPTaku Codex Plugins

`fivetaku/gptaku_plugins`를 **Codex 전용 워크플로우**로 재구성한 포크입니다.

원본은 Claude Code 플러그인 마켓플레이스용이지만, 이 포크는 아래에 집중합니다.

- Claude 전용 `/plugin ...` 설치 흐름 제거
- Codex skill 설치/관리 스크립트 제공
- Claude 전용 패턴(`AskUserQuestion`, `${CLAUDE_PLUGIN_ROOT}`) 호환성 분석 제공

원본 저장소: <https://github.com/fivetaku/gptaku_plugins>

## 빠른 시작

1. 저장소 클론 + 서브모듈 초기화

```bash
git clone --recurse-submodules https://github.com/dudqks0319-cpu/gptaku_plugins.git
cd gptaku_plugins
```

2. 설치 가능한 플러그인 목록 확인

```bash
bash scripts/list-codex-plugins.sh
```

3. 원하는 플러그인의 skill을 Codex 홈에 설치

```bash
bash scripts/install-codex-plugin.sh <plugin-name>
```

예시:

```bash
bash scripts/install-codex-plugin.sh pumasi
```

기본 설치 경로는 `${CODEX_HOME:-$HOME/.codex}/skills` 입니다.

## 호환성 점검

서브모듈을 받은 뒤 아래로 Claude 전용 패턴 잔존 여부를 확인할 수 있습니다.

```bash
bash scripts/audit-codex-compat.sh
```

특정 플러그인만 확인하려면:

```bash
bash scripts/audit-codex-compat.sh deep-research
```

## 현재 호환성 상태 (초기 분석)

| Plugin | Codex 적합도 | 메모 |
| --- | --- | --- |
| docs-guide | Medium | skill 중심 사용 가능, 일부 Claude 경로 참조 존재 |
| git-teacher | Low | `AskUserQuestion` 의존 흐름이 많아 추가 변환 필요 |
| vibe-sunsang | Low | Claude 전용 인터랙션/경로 참조가 혼합됨 |
| deep-research | Low | `AskUserQuestion`, `Task` 기반 오케스트레이션 치환 필요 |
| pumasi | Medium | Codex 지향적이지만 경로/명령 래퍼 보정 필요 |
| show-me-the-prd | Medium | 대화형 플로우는 재설계 필요, skill 자산은 재사용 가능 |
| kkirikkiri | Medium | 멀티에이전트 설계는 재사용 가능, 실행 인터페이스 보정 필요 |
| skillers-suda | Medium | skill 자산 재사용 가능, 실행 라우팅은 Codex화 필요 |

세부 근거는 [docs/codex-migration-analysis.md](docs/codex-migration-analysis.md)에서 확인하세요.

## 디렉토리

- `plugins/`: 원본 플러그인 서브모듈
- `scripts/`: Codex 전용 운영 스크립트
- `docs/`: 마이그레이션 분석/전환 가이드

## 기여

Codex 호환성 개선 PR 환영합니다.

권장 우선순위:
1. `AskUserQuestion` 기반 플로우를 Codex 대화형/자동 결정 플로우로 변환
2. `${CLAUDE_PLUGIN_ROOT}` 참조를 skill 상대 경로로 치환
3. Claude 전용 command front-matter 의존 제거

## License

원본과 동일하게 MIT를 따릅니다.
