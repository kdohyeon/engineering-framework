---
description: "[Workflow 5/9] 릴리즈 계획 — Backlog에서 이슈 선택, 브랜치 생성"
---

## 역할
릴리즈를 시작할 때 실행한다.
Backlog에서 이번 버전에 포함할 이슈를 선택하고 브랜치를 준비한다.

사용법: `/wf-release-plan v1.0.2`

## 실행

$ARGUMENTS 가 버전 번호이면 그것을 사용한다.
없으면 사용자에게 버전을 질문한다: "이번 릴리즈 버전을 입력하세요 (예: v1.0.2):"

## 1단계: Backlog 이슈 확인

Milestone이 없는 오픈 이슈 목록을 가져온다:

```bash
gh issue list --no-assignee --state open --json number,title,labels \
  | jq '.[] | select(.milestone == null)'
```

이슈 목록을 출력하고 사용자에게 이번 릴리즈에 포함할 이슈를 선택하게 한다:

```
─────────────────────────────────
Backlog 이슈 목록:
  #1 [FEAT] 스트릭 타임존 버그 수정  (bug)
  #2 [FEAT] 리마인더 알림 설정       (feature)
  #3 [FEAT] 홈화면 위젯              (feature)

v1.0.2에 포함할 이슈 번호를 입력하세요 (쉼표 구분):
─────────────────────────────────
```

## 2단계: GitHub Milestone 생성

```bash
gh api repos/:owner/:repo/milestones \
  --method POST \
  --field title="v1.0.2" \
  --field description="v1.0.2 릴리즈"
```

## 3단계: 선택한 이슈에 Milestone 할당

선택된 각 이슈에 Milestone을 할당한다:

```bash
gh issue edit [번호] --milestone "v1.0.2"
```

## 4단계: release 브랜치 생성

```bash
git checkout main
git pull origin main
git checkout -b release/v1.0.2
git push origin release/v1.0.2
```

## 5단계: state.json 업데이트

`.workflow/state.json` 업데이트:

```json
{
  "current_release": "v1.0.2",
  "release_branch": "release/v1.0.2",
  "stage": "implement",
  "pending_issues": [선택된 이슈 번호들],
  "completed_issues": [],
  "last_updated": "오늘 날짜"
}
```

## 완료 후 안내

```
─────────────────────────────────
릴리즈 v1.0.2 준비 완료:
  브랜치: release/v1.0.2
  포함 이슈: #1, #2

구현을 시작하려면:
  /wf-implement 1   ← 이슈 번호로 구현 시작
─────────────────────────────────
```
