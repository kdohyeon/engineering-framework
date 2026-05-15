# 릴리즈 관리

## 버전 규칙 (Semantic Versioning)

```
v[MAJOR].[MINOR].[PATCH]

v1.0.0  - MVP 최초 출시
v1.1.0  - 새 기능 추가 (minor)
v1.1.1  - 버그 픽스 / 핫픽스 (patch)
v2.0.0  - 하위 호환 불가한 큰 변경 (major)
```

---

## 정규 릴리즈 절차

### 1. Backlog → Milestone 할당

```
이번 릴리즈에 넣을 이슈 선택 → Milestone: v1.1.0 설정
```

### 2. release 브랜치 생성

```bash
git checkout main
git pull origin main
git checkout -b release/v1.1.0
git push origin release/v1.1.0
```

### 3. 기능 개발 (feature 브랜치)

```bash
# 각 이슈마다 반복
git checkout release/v1.1.0
git checkout -b feature/23-darkmode

# 개발 완료 후 develop에서 테스트
git checkout develop
git merge feature/23-darkmode
# 테스트 확인

# develop 테스트 OK → feature → release PR
# PR: feature/23-darkmode → release/v1.1.0
```

### 4. release 브랜치 최종 테스트

모든 feature가 release에 merge된 후 통합 테스트 진행.

### 5. CHANGELOG.md 업데이트

```markdown
## [1.1.0] - 2026-08-01

### Added
- 다크 모드 지원 (#23)
- 알림 기능 (#24)

### Fixed
- 프로필 이미지 로딩 오류 (#31)
```

### 6. release → main merge

```bash
# PR: release/v1.1.0 → main
# merge 후:
git tag -a v1.1.0 -m "v1.1.0"
git push origin v1.1.0
```

### 7. GitHub Release 생성

```bash
gh release create v1.1.0 \
  --title "v1.1.0 - 다크 모드, 알림 기능" \
  --notes-file RELEASE_NOTES.md
```

---

## 핫픽스 릴리즈 절차

긴급 장애는 release 브랜치를 거치지 않고 main에서 직접.

```bash
# 1. main 기준으로 hotfix 브랜치 생성
git checkout main
git checkout -b hotfix/56-payment-failure

# 2. 수정 후 PR: hotfix/56 → main
# 3. merge 후 패치 버전 태그
git tag -a v1.1.1 -m "v1.1.1 - 결제 오류 긴급 수정"
git push origin v1.1.1

# 4. GitHub Release 생성
gh release create v1.1.1 \
  --title "v1.1.1 - 결제 오류 긴급 수정" \
  --notes "결제 API 연동 오류 긴급 패치"
```

---

## 릴리즈 노트 작성 가이드

**유저 관점으로** 작성. 기술 용어 최소화.

```markdown
## 🎉 v1.1.0

### 새로운 기능
- **다크 모드** - 눈에 편한 어두운 테마를 지원합니다
- **알림** - 중요한 업데이트를 놓치지 마세요

### 개선
- 앱 시작 속도 30% 개선

### 버그 수정
- 프로필 이미지가 간헐적으로 안 보이는 문제 수정

---
전체 변경 내역: [CHANGELOG.md](CHANGELOG.md)
```

---

## 릴리즈 체크리스트

```
[ ] 해당 Milestone 이슈 전부 Close 확인
[ ] release/** 브랜치 통합 테스트 완료
[ ] CHANGELOG.md 업데이트
[ ] release/** → main PR merge
[ ] git tag 생성 및 push
[ ] GitHub Release 생성 (릴리즈 노트 포함)
[ ] 배포 완료 확인 (수동)
[ ] Slack 알림 확인
```
