# Gemini Adapter: docs-guide

## Goal
공식 문서 기반으로 정확한 답변 제공.

## Input Handling
- 인수 형식: `[library] [question]`
- 인수가 없으면 질문 1개만 한다: `라이브러리 + 궁금한 포인트를 한 줄로 알려주세요.`

## Execution
1. 라이브러리 공식 문서 도메인 식별
2. `llms.txt` 또는 공식 문서 페이지 우선 조회
3. 필요 시 웹 검색으로 공식 도메인만 사용
4. 결과 요약 시 Gemini CLI를 보조로 사용 가능

## Constraints
- 비공식 블로그/포럼은 1차 근거로 사용하지 않는다.
- 답변 끝에 source URL을 반드시 명시한다.
