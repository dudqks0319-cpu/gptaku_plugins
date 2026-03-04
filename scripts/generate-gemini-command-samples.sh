#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out_root="${repo_root}/examples/gemini-only"

mkdir -p "${out_root}"

cat > "${out_root}/README.md" <<'EOF'
# Gemini-Only Command Samples

이 폴더는 GPTaku 원본 8개 command에 대한 Gemini-only 샘플 입력/출력 예시입니다.

## Files
- `docs-guide.md`
- `git-teacher.md`
- `vibe-sunsang.md`
- `deep-research.md`
- `pumasi.md`
- `show-me-the-prd.md`
- `kkirikkiri.md`
- `skillers-suda.md`

## Usage
각 파일에서 `Prompt`를 그대로 사용해 실행 테스트를 시작하고,
`Expected Output Checklist` 기준으로 결과를 검증하세요.
EOF

cat > "${out_root}/docs-guide.md" <<'EOF'
# /docs-guide Sample (Gemini-only)

## Prompt
```text
/docs-guide react useEffect cleanup pattern 알려줘
```

## Expected Output Checklist
- React 공식 문서 기준 설명 포함
- 코드 예시 1개 이상 포함
- source URL 1개 이상 포함
- 한국어 질의면 한국어 응답
- 비공식 출처를 1차 근거로 쓰지 않음
EOF

cat > "${out_root}/git-teacher.md" <<'EOF'
# /git-teacher Sample (Gemini-only)

## Prompt
```text
/git-teacher 시작
```

## Expected Output Checklist
- 현재 환경 확인 순서 제시 (`git`, `gh`, 인증 상태)
- 초보자용 설명(기술 용어 최소화)
- 위험 명령 실행 전 확인 안내
- 다음 단계가 번호 목록으로 제시됨
- Claude 전용 AskUserQuestion 가정 없이 진행
EOF

cat > "${out_root}/vibe-sunsang.md" <<'EOF'
# /vibe-sunsang Sample (Gemini-only)

## Prompt
```text
/vibe-sunsang 성장
```

## Expected Output Checklist
- 최근 작업 회고 포인트 요약
- 강점 2개, 개선 포인트 2개 제시
- 바로 실행 가능한 행동 3개 제시
- 출력이 코칭 중심이며 과도한 도구 설명 없음
- 필요 시 Gemini 요약 보조를 사용해도 결과 형식은 일관됨
EOF

cat > "${out_root}/deep-research.md" <<'EOF'
# /deep-research Sample (Gemini-only)

## Prompt
```text
/deep-research 한국 배달앱 시장 2026 경쟁 구도
```

## Expected Output Checklist
- 리서치 범위/질문이 명확히 정의됨
- 출처 URL 포함된 핵심 주장 제시
- 세션 경로(`RESEARCH/...`) 또는 상태 추적 정보 제시
- 요약/구조화 단계가 분리되어 설명됨
- AskUserQuestion 다중 인터뷰 없이도 진행 가능
EOF

cat > "${out_root}/pumasi.md" <<'EOF'
# /pumasi Sample (Gemini-only)

## Prompt
```text
/pumasi 기존 Next.js 서비스에 구독 결제 + 관리자 매출 리포트 + 알림 기능 추가
```

## Expected Output Checklist
- 작업을 독립 서브태스크로 분해
- 병렬 실행 계획(역할, 순서, 게이트) 제시
- 최종 통합/검증 단계 명시
- 외부 분석이 필요할 때 Gemini만 사용
- 외부 codex CLI 워커 호출 금지 정책 준수
EOF

cat > "${out_root}/show-me-the-prd.md" <<'EOF'
# /show-me-the-prd Sample (Gemini-only)

## Prompt
```text
/show-me-the-prd 반려동물 산책 기록 앱 만들고 싶어
```

## Expected Output Checklist
- PRD 문서 세트 생성 경로 제시 (`PRD/01..04`)
- 기능 목록 + 데이터 모델 + 단계(Phase) 포함
- 선택한 스택 근거를 짧게 제시
- 질문은 최대 3개 내에서 핵심만 수행
- 결과가 바로 개발 시작 가능한 수준으로 정리됨
EOF

cat > "${out_root}/kkirikkiri.md" <<'EOF'
# /kkirikkiri Sample (Gemini-only)

## Prompt
```text
/kkirikkiri 한국 B2B SaaS 경쟁사 리서치 팀 만들어줘
```

## Expected Output Checklist
- 프리셋 매칭 결과(리서치/개발/분석/콘텐츠 중 하나) 제시
- 팀 역할 분리 계획 제시
- 실행/검증/리포트 단계가 명확함
- Claude 전용 TeamCreate/AskUserQuestion 전제 없이 동작
- 대규모 요약은 Gemini-only 정책을 따름
EOF

cat > "${out_root}/skillers-suda.md" <<'EOF'
# /skillers-suda Sample (Gemini-only)

## Prompt
```text
/skillers-suda 슬랙 메시지에서 액션아이템 추출해서 노션에 정리하는 스킬 만들어줘
```

## Expected Output Checklist
- 목적/트리거/입력/출력 정의 포함
- 단계별 워크플로우(SKILL.md 형태) 제시
- 실패 케이스/예외 처리 지침 포함
- 즉시 실행 가능한 초안으로 작성
- AskUserQuestion 의존 없이 진행 가능
EOF

echo "[OK] Generated Gemini-only samples in: ${out_root}"
