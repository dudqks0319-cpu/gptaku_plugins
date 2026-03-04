# Runtime Adapter: git-teacher (codex53xhigh-ui-gemini)

## Engine Routing
- 전 단계 Codex (`codex-5.3`, reasoning `xhigh`)
- UI 작업이 아니므로 Gemini 라우팅 없음

## Execution
1. 인수 파싱(시작/상태/저장/올리기/검토/도움말)
2. 인수 없으면 `상태` 기본값
3. 초보자 관점 안내 + 안전 가드 유지

## Constraints
- AskUserQuestion 전제 금지
- 파괴적 명령은 사용자 의도 확인 후에만
