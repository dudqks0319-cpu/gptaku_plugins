# Gemini Adapter: vibe-sunsang

## Goal
AI 활용 성장 멘토링 워크플로우를 Codex에서 재현.

## Input Handling
- 지원 인수: 시작/변환/멘토링/성장
- 인수 없으면 기본값은 `멘토링`.

## Execution
1. 해당 모드 skill 문서를 읽고 체크리스트 기반으로 실행
2. 로그/회고 텍스트 요약이 길면 Gemini CLI 보조 요약 사용
3. 최종 결과는 `실행한 분석 + 다음 행동 3개` 형태로 제공

## Constraints
- Claude 전용 경로 변수는 설치된 skill 경로로 치환한다.
- 질문은 최대 1개만 텍스트로 묻고, 나머지는 기본값으로 진행한다.
