# Profile: codex53xhigh-ui-gemini

기준일: 2026-03-04

## 정책

- 기본 실행자: **Codex (`codex-5.3`, reasoning `xhigh`)**
- 예외 실행자: **Gemini CLI (UI/UX/디자인 작업에 한정)**

## UI 작업 판정 기준

다음 유형이면 Gemini 라우팅 허용:
- UI 화면 구조
- UX 플로우
- 디자인 시스템
- 컴포넌트 스타일/타이포/컬러/spacing
- 반응형 레이아웃

그 외 작업(백엔드, API, 데이터, 테스트, 자동화, 리서치 본문)은 Codex로 처리한다.

## 설치

```bash
bash scripts/install-all-codex-plugins.sh --profile codex53xhigh-ui-gemini
```

또는 기본값으로 동일:

```bash
bash scripts/install-all-codex-plugins.sh
```

## 런타임 점검

```bash
bash scripts/check-runtime-profile.sh codex53xhigh-ui-gemini
```

## 운영 규칙

1. command shim은 `SOURCE_COMMAND.md` + `ADAPTER.md`를 함께 읽고 실행한다.
2. 실행 전에 UI 여부를 판단해 라우팅을 선택한다.
3. 결과 보고 시 `engine routing` 한 줄을 포함한다.

예시:
- `Engine routing: Codex(backend/test) + Gemini(ui layout)`
