# Runtime Adapter: skillers-suda (codex53xhigh-ui-gemini)

## Engine Routing
- 기본: Codex (`codex-5.3`, reasoning `xhigh`)
- 생성하려는 skill이 UI/UX 설계형일 때만 Gemini 보조

## Execution
1. 신규 스킬 생성/기존 스킬 분석 분기
2. 기획/기술/검수 논리는 Codex 중심
3. UI 중심 스킬일 때 디자인 파트 초안만 Gemini 보조
4. 최종 SKILL.md는 Codex가 확정
