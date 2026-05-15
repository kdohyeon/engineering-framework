---
description: "[Workflow 8/9] 배포 — release → main merge, 태그, GitHub Release, CHANGELOG"
---

## 역할
테스트가 완료된 release 브랜치를 main에 merge하고 릴리즈를 완성한다.

## 실행

`.workflow/state.json`에서 릴리즈 정보를 읽는다.

## 배포 전 최종 체크리스트

배포를 시작하기 전 반드시 확인한다:

```
─────────────────────────────────
배포 전 체크리스트:
  [ ] 모든 milestone 이슈가 release 브랜치에 merge됨
  [ ] /wf-test 통과 완료
  [ ] CHANGELOG.md 업데이트 준비

위 항목을 확인했습니까? (Y/N)
─────────────────────────────────
```

## 1단계: CHANGELOG.md 업데이트

CHANGELOG.md 파일을 열어 `[Unreleased]` 섹션을 현재 버전으로 업데이트한다.

milestone의 closed issue 목록을 가져와서 자동으로 항목을 채운다:

```bash
gh issue list --milestone "[버전]" --state closed \
  --json number,title,labels
```

```markdown
## [1.0.2] - 오늘날짜

### Fixed
- 스트릭 타임존 버그 수정 (#1)

### Added
- 리마인더 알림 설정 (#2)
```

CHANGELOG.md 수정 후 커밋:
```bash
git checkout release/[버전]
git add CHANGELOG.md
git commit -m "chore: CHANGELOG v[버전] 업데이트"
```

## 2단계: release → main PR 생성 및 merge

```bash
gh pr create \
  --base main \
  --head release/[버전] \
  --title "release: [버전]" \
  --body "## 릴리즈 [버전]

### 포함 이슈
[이슈 목록]

### 테스트 완료
- [ ] 통합 테스트 통과"
```

PR merge 후:

```bash
git checkout main
git pull origin main
```

## 3단계: 버전 태그 생성

```bash
git tag -a v[버전] -m "v[버전]"
git push origin v[버전]
```

## 4단계: GitHub Release 생성

릴리즈 노트를 유저 관점으로 작성한다 (기술 용어 최소화):

```bash
gh release create v[버전] \
  --title "v[버전] - [릴리즈 한 줄 요약]" \
  --notes "$(cat <<'EOF'
## 새로운 기능
- **리마인더 알림**: 습관별 알림 시간을 직접 설정할 수 있습니다

## 버그 수정
- 자정 이후에 습관을 체크해도 스트릭이 끊기지 않습니다

전체 변경 내역: [CHANGELOG.md 링크]
EOF
)"
```

## 5단계: state.json 업데이트

```json
{
  "current_release": null,
  "release_branch": null,
  "stage": "monitor",
  "pending_issues": [],
  "completed_issues": [],
  "last_updated": "오늘 날짜"
}
```

## 완료 후 안내

```
─────────────────────────────────
v[버전] 배포 완료 ✓

  태그: v[버전]
  GitHub Release: [URL]
  CHANGELOG: 업데이트 완료

배포 후 모니터링을 시작합니다: /wf-monitor
─────────────────────────────────
```
