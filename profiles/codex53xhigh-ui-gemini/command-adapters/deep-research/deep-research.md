# Runtime Adapter: deep-research (codex53xhigh-ui-gemini)

## Engine Routing
- 기본: Codex (`codex-5.3`, reasoning `xhigh`)
- UI/UX 리서치 주제에만 Gemini 보조 허용

## Execution
1. `resume/status/query/new-topic` 분기
2. 근거 수집/구조화/출력은 Codex 중심
3. UI 트렌드 비교 테이블이 필요할 때만 Gemini 보조
4. 주장마다 출처 URL 포함
