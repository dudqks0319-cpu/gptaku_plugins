# Gemini Adapter: git-teacher

## Goal
비개발자 Git/GitHub 온보딩을 단계별로 안내.

## Input Handling
- 지원 인수: 시작/상태/저장/올리기/검토/도움말
- 인수 없으면 기본값은 `상태`로 실행한다.

## Execution
1. 상태 확인은 읽기 전용 명령부터 (`git status -sb`, `git branch --show-current`)
2. 저장/올리기 전에는 변경 파일 요약을 먼저 보여준다.
3. 검토(PR)는 원격/인증 상태를 확인한 후 진행한다.

## Constraints
- 사용자가 명시하지 않은 파괴적 명령은 실행하지 않는다.
- 인증이 필요한 단계는 한 줄 안내 후 진행한다.
- AskUserQuestion 도구를 가정하지 않는다.
