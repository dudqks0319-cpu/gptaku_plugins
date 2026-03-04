# Gemini Adapter: deep-research

## Goal
리서치 세션 생성/재개/상태 확인을 Codex에서 안정적으로 수행.

## Input Handling
- `resume <id>`: 세션 재개
- `status`: 세션 목록/진행도
- `query`: 구조화 질의 생성
- 그 외: 새 리서치 주제
- 인수 없으면 질문 1개: `리서치할 주제를 한 줄로 알려주세요.`

## Execution
1. 세션 루트는 `RESEARCH/` 하위 사용
2. 웹 근거 수집 후 Gemini CLI로 1차 구조화 요약 가능
3. 핵심 주장에는 출처 URL 포함
4. 진행 상태 파일(`state.json`) 갱신

## Constraints
- AskUserQuestion 기반 다중 인터뷰를 강제하지 않는다.
- 외부 실행자는 gemini CLI만 허용한다.
