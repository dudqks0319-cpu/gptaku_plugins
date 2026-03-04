# Codex Migration Analysis

기준일: 2026-03-04
대상: `fivetaku/gptaku_plugins` + 연결된 서브모듈 플러그인

## 1. 구조 분석 요약

원본 리포는 다음 구조를 사용합니다.

- 루트 마켓플레이스 메타: `.claude-plugin/marketplace.json`
- 플러그인 목록: `plugins/*` (git submodule)
- 각 플러그인 내부:
  - `.claude-plugin/plugin.json`
  - `commands/*.md` (Claude `/command` 엔트리)
  - `skills/*/SKILL.md`

핵심 관찰:
- 실제 도메인 지식/워크플로우 자산은 `skills/`에 집중되어 있음
- 실행 라우팅은 `commands/` + Claude 도구 전제(`AskUserQuestion`, `Task`)에 묶여 있음

## 2. Codex 전환 시 블로커

### A. 인터랙션 API 차이

원본에서 자주 등장하는 `AskUserQuestion` 전제는 Codex에서 동일 형태로 호환되지 않습니다.

영향:
- 무인 실행(autopilot) 흐름으로 바꾸거나
- 짧은 텍스트 질의 방식으로 재설계 필요

### B. 런타임 경로 변수 차이

원본 skill은 `${CLAUDE_PLUGIN_ROOT}` 참조를 다수 사용합니다.

영향:
- Codex skill 배포 경로 기준 상대 경로/절대 경로 보정 필요

### C. 오케스트레이션 도구 명칭 차이

원본은 `Task tool` 중심 지시가 많고, Codex는 `spawn_agent`/`send_input`/`wait` 등으로 구성됩니다.

영향:
- 멀티에이전트 실행 지시문을 Codex 도구 체계로 변환 필요

### D. 설치 인터페이스 차이

원본은 `/plugin marketplace add`, `/plugin install` 기반입니다.

영향:
- Codex용 설치 스크립트/운영 문서가 별도로 필요

## 3. 플러그인별 초기 적합도

초기 적합도는 저장소 코드 패턴 스캔과 샘플 파일 확인 기반의 1차 등급입니다.

| Plugin | 등급 | 판단 근거 |
| --- | --- | --- |
| docs-guide | Medium | skill 재사용 가능, Claude 경로 참조 일부 존재 |
| git-teacher | Low | `AskUserQuestion` 의존도 높음 |
| vibe-sunsang | Low | `AskUserQuestion`/Claude 경로 참조 다수 |
| deep-research | Low | 인터랙션+오케스트레이션 치환 필요 |
| pumasi | Medium | Codex 지향 설계지만 경로/래퍼 보정 필요 |
| show-me-the-prd | Medium | 자산 재사용 가능, 인터랙션 재설계 필요 가능성 |
| kkirikkiri | Medium | 팀 설계 논리 재사용 가능, 실행 인터페이스 보정 필요 |
| skillers-suda | Medium | skill 자산 재사용 가능, 실행 라우팅 보정 필요 |

## 4. 권장 전환 전략

### Phase 1 (완료)

- Codex 전용 포크 생성
- Codex 설치/목록/호환성 점검 스크립트 추가
- 전환 분석 문서화

### Phase 2 (추천)

- 각 플러그인별 `codex-shim` 문서/어댑터 작성
- `AskUserQuestion` 흐름을 Codex 친화형 자동/단문 질의 흐름으로 치환

### Phase 3 (추천)

- 호환성 CI 스캔 도입 (금지 패턴 검사)
- 플러그인별 Codex readiness 배지 자동 갱신

## 5. 보안 관점 메모

- 현재 전환은 문서/스크립트 레벨이며, 런타임 비밀값 하드코딩은 추가하지 않음
- 서브모듈 기반 공급망이므로 pin(commit SHA) 유지 및 주기적 업데이트 검토 필요
- 자동 실행 스크립트는 사용자 홈(`$CODEX_HOME`) 이하만 대상으로 동작하도록 제한
