# Runtime Adapter: docs-guide (codex53xhigh-ui-gemini)

## Primary Engine
- 기본: Codex (`codex-5.3`, reasoning `xhigh`)

## Gemini Trigger (UI only)
아래와 같이 UI/UX 문서 질문일 때만 Gemini를 보조 사용한다.
- `tailwind`, `css layout`, `responsive`, `design system`, `typography`, `spacing`

## Execution
1. 공식 문서 도메인 우선 확인
2. 비-UI 주제는 Codex만 사용
3. UI 주제는 Gemini로 비교 요약 후 Codex가 최종 정리
4. source URL 명시
