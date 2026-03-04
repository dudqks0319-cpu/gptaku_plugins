#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out_root="${repo_root}/examples/codex53xhigh-ui-gemini"

mkdir -p "${out_root}"

cat > "${out_root}/README.md" <<'EOF'
# Command Samples (codex53xhigh-ui-gemini)

정책:
- 기본: Codex 5.3 xhigh
- UI/UX/디자인 파트: Gemini

각 샘플은 `Expected Router`와 `Expected Output Checklist`를 포함합니다.
EOF

cat > "${out_root}/docs-guide.md" <<'EOF'
# /docs-guide Sample

## Prompt
```text
/docs-guide tailwind css responsive grid best practice
```

## Expected Router
- Gemini (UI 문서 질의)

## Expected Output Checklist
- 공식 문서 기반 핵심 요약
- 실전 코드 예시 1개 이상
- source URL 포함
- UI 문서라도 과장 표현 없이 근거 중심
EOF

cat > "${out_root}/git-teacher.md" <<'EOF'
# /git-teacher Sample

## Prompt
```text
/git-teacher 시작
```

## Expected Router
- Codex 5.3 xhigh

## Expected Output Checklist
- 단계별 온보딩 안내
- 현재 상태 점검 명령 제시
- 위험 작업 전 확인 안내
EOF

cat > "${out_root}/vibe-sunsang.md" <<'EOF'
# /vibe-sunsang Sample

## Prompt
```text
/vibe-sunsang 성장
```

## Expected Router
- Codex 5.3 xhigh (기본)

## Expected Output Checklist
- 강점/개선 포인트 균형
- 다음 행동 3개
- 코칭 중심 결과
EOF

cat > "${out_root}/deep-research.md" <<'EOF'
# /deep-research Sample

## Prompt
```text
/deep-research 한국 SaaS 보안 컴플라이언스 트렌드 2026
```

## Expected Router
- Codex 5.3 xhigh

## Expected Output Checklist
- 리서치 범위 명확화
- 근거 URL 포함 주장
- 상태 추적 구조 제시
EOF

cat > "${out_root}/pumasi.md" <<'EOF'
# /pumasi Sample

## Prompt
```text
/pumasi 백엔드 결제 API + 관리자 대시보드 UI 개편 + 테스트 자동화
```

## Expected Router
- Codex 5.3 xhigh: API/테스트
- Gemini: 대시보드 UI 개편

## Expected Output Checklist
- 서브태스크 분해
- 라우팅 이유 명시
- 통합 검증 단계 포함
EOF

cat > "${out_root}/show-me-the-prd.md" <<'EOF'
# /show-me-the-prd Sample

## Prompt
```text
/show-me-the-prd 식당 예약 앱 PRD 만들어줘. UX 흐름도 자세히 넣어줘
```

## Expected Router
- Codex 5.3 xhigh: PRD 구조/기능/데이터
- Gemini: UX 흐름/화면 구조 섹션

## Expected Output Checklist
- PRD 4종 문서 경로
- 기능/데이터 모델/Phase 포함
- UX 섹션 반영
EOF

cat > "${out_root}/kkirikkiri.md" <<'EOF'
# /kkirikkiri Sample

## Prompt
```text
/kkirikkiri 신규 SaaS 온보딩 UX 개선 + API 성능 분석 팀 만들어줘
```

## Expected Router
- Codex 5.3 xhigh: 팀 운영/분석 역할
- Gemini: UX 개선 역할

## Expected Output Checklist
- 역할 분리 계획
- 실행 단계/검증 단계
- 최종 보고 구조
EOF

cat > "${out_root}/skillers-suda.md" <<'EOF'
# /skillers-suda Sample

## Prompt
```text
/skillers-suda 피그마 시안 기반 UI 컴포넌트 생성 스킬 만들어줘
```

## Expected Router
- Gemini (UI 중심 설계)
- Codex 5.3 xhigh (구조/검수/실행 규칙 확정)

## Expected Output Checklist
- 트리거/입력/출력 정의
- 단계별 워크플로우
- 실패/예외 처리 규칙
EOF

echo "[OK] Generated samples: ${out_root}"
