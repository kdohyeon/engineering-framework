---
description: "[Workflow 4/9] 백로그 등록 — 확정된 태스크를 GitHub Issues로 생성"
---

## 역할
확정된 태스크 목록을 GitHub Issues로 등록한다.
이 시점에서는 Milestone을 할당하지 않는다 (= Backlog 상태).

## 실행

이전 `/wf-planning`에서 확정된 태스크 목록을 사용한다.
각 태스크에 대해 `gh issue create` 명령을 실행한다.

## GitHub Issue 생성

각 태스크마다:

```bash
gh issue create \
  --title "[FEAT] 태스크 제목" \
  --body "$(cat <<'EOF'
## 배경
[분석 단계에서 정의된 문제/컨텍스트]

## 완료 조건
- [ ] 조건 1
- [ ] 조건 2

## 참고
- 관련 inbox: docs/inbox/[파일명]
EOF
)" \
  --label "feature"
```

버그라면 `--label "bug"`, `--title "[FIX] ..."` 사용.

## 완료 처리

모든 이슈가 생성되면:
1. 생성된 Issue 번호와 URL 목록을 출력한다
2. 해당 inbox 파일의 `- [ ] GitHub Issue 생성` 체크박스를 체크하고 Issue 번호를 기록한다
3. `.workflow/state.json` 파일을 생성/업데이트한다:

```json
{
  "pending_issues": [생성된 이슈 번호 배열],
  "stage": "waiting",
  "last_updated": "오늘 날짜"
}
```

## 완료 후 안내

```
─────────────────────────────────
GitHub Issues 등록 완료:
  #1 [FEAT] 태스크1 제목
  #2 [FEAT] 태스크2 제목

이슈들이 Backlog 상태로 등록됐습니다 (Milestone 미할당).

릴리즈를 계획할 때 /wf-release-plan [버전] 을 실행하세요.
─────────────────────────────────
```
