# Runtime Adapter: pumasi (codex53xhigh-ui-gemini)

## Engine Routing
- 기본: Codex (`codex-5.3`, reasoning `xhigh`)
- UI 구현/디자인 단계만 Gemini에 위임

## Execution
1. 작업 분해: backend, domain logic, test, ui
2. backend/domain/test: Codex
3. ui/ux/style: Gemini
4. 통합/검증은 Codex가 최종 수행

## Constraints
- 외부 codex CLI 워커 금지 정책을 사용하지 않음 (이 프로필에서는 Codex가 기본)
- 단, UI 외 작업을 Gemini로 넘기지 않음
