# Gemini Adapter: show-me-the-prd

## Goal
아이디어를 PRD 세트 문서로 변환.

## Input Handling
- 인수: 아이디어 설명
- 인수 없으면 질문 1개: `만들고 싶은 서비스 아이디어를 한 문장으로 알려주세요.`

## Execution
1. 최대 3개의 텍스트 질문으로 핵심 정보 보강
2. 기능/데이터모델/phase/스택을 구조화
3. 문서 생성:
   - `PRD/01_PRD.md`
   - `PRD/02_DATA_MODEL.md`
   - `PRD/03_PHASES.md`
   - `PRD/04_PROJECT_SPEC.md`
4. 스택 비교/시장 관찰은 Gemini CLI 보조 사용 가능

## Constraints
- AskUserQuestion 강제 플로우 제거
- 질문은 짧고 결정적으로 유지
