# Gemini Adapter: skillers-suda

## Goal
아이디어를 실행 가능한 skill 초안으로 변환하고, 기존 skill 분석 모드 제공.

## Input Handling
- `분석 <path>`: 기존 skill 분석
- 그 외: 새 skill 생성
- 인수 없으면 기본값은 `새 스킬 만들기`

## Execution
1. 새 스킬: 목적/트리거/워크플로우/에러처리 순으로 설계
2. 분석 모드: 기획/사용성/기술/검수 관점 진단
3. 결과를 바로 수정안 형태로 제시
4. 브레인스토밍/옵션 비교는 Gemini CLI로 보조 가능

## Constraints
- AskUserQuestion 강제 전제 제거
- 결과는 즉시 실행 가능한 체크리스트 중심
