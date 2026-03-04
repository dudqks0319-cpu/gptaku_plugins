# Gemini Adapter: kkirikkiri

## Goal
자연어 요청을 팀 실행 플로우로 변환.

## Input Handling
- 인수 없으면 기본값: `팀 만들기`
- 필요 시 질문 1개: `어떤 결과물을 팀으로 만들고 싶은지 한 줄로 알려주세요.`

## Execution
1. 프리셋(리서치/개발/분석/콘텐츠) 매칭
2. Codex agent로 팀 역할 분리 실행
3. 외부 대규모 요약/분석은 Gemini CLI로만 수행
4. 결과 리포트 + 다음 단계 제시

## Constraints
- TeamCreate/AskUserQuestion 같은 Claude 전용 API 전제 금지
- 팀 구성은 텍스트 계획 + agent spawn으로 치환
