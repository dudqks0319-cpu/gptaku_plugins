# Gemini Adapter: pumasi

## Goal
병렬 작업 분해/실행 워크플로우를 Gemini-only 제약 하에 유지.

## Input Handling
- 인수: 작업 설명
- 인수 없으면 질문 1개: `병렬로 처리할 작업을 한 줄로 설명해주세요.`

## Execution
1. 작업을 독립 서브태스크로 분해
2. Codex agent 병렬 실행으로 구현/검증 수행
3. 외부 보조 분석이 필요할 때만 Gemini CLI 호출
4. 최종 통합 전 게이트(타입/테스트/빌드) 확인

## Constraints
- 외부 codex CLI 워커 호출 금지
- Claude OAuth/Claude CLI 전제 금지
