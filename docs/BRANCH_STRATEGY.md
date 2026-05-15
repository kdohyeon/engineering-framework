# 브랜치 전략

## 브랜치 구조

```
main  ──────────────────────────────────────────────── (프로덕션)
  │                                          ↑
  ├── release/v1.0.0 ──────────────────── merge
  │       │                        ↑
  │       ├── feature/12-login ──merge
  │       └── feature/15-profile ─merge
  │
  ├── release/v1.1.0 ──────────────────── merge
  │       │
  │       └── feature/23-darkmode
  │
  └── hotfix/56-payment ─────────────── merge (긴급, 직접 main으로)

develop  ← feature/** 에서 임시로 merge해서 테스트 (언제든 재생성 가능)
```

---

## main

- **항상 배포 가능한 프로덕션 상태**
- 직접 커밋 금지
- `release/**` 또는 `hotfix/**` PR을 통해서만 변경
- merge될 때마다 버전 태그 생성 + GitHub Release

---

## develop

- **통합 테스트 전용 임시 브랜치**
- feature 브랜치 작업이 끝나면 develop에 merge해서 동작 확인
- **언제든 삭제하고 main 기준으로 재생성해도 됨**
- develop에서 테스트가 통과해야 feature → release merge 진행

```bash
# develop이 오염됐을 때 재생성
git branch -D develop
git checkout main
git checkout -b develop
git push -f origin develop
```

---

## release/vX.Y.Z

- **버전별 릴리즈 준비 브랜치**
- main을 기준으로 생성
- 해당 버전에 할당된 feature들이 여기로 merge됨
- 릴리즈 전 최종 테스트 진행
- 완료되면 main으로 merge 후 태그 생성

```bash
# release 브랜치 생성 (main 기준)
git checkout main
git pull origin main
git checkout -b release/v1.1.0
git push origin release/v1.1.0
```

**네이밍:** `release/v[MAJOR].[MINOR].[PATCH]`

---

## feature/N-이름

- **기능 하나를 구현하는 브랜치**
- `release/**` 브랜치를 기준으로 생성 (main이 아님)
- 생성 전제조건: GitHub Issue가 특정 Milestone(버전)에 할당되어 있어야 함

```bash
# 1. 해당 release 브랜치 기준으로 생성
git checkout release/v1.1.0
git checkout -b feature/23-darkmode

# 2. 개발 완료 후 develop에 merge해서 테스트
git checkout develop
git merge feature/23-darkmode

# 3. develop 테스트 OK → feature → release PR 생성
# PR: feature/23-darkmode → release/v1.1.0
```

**네이밍:** `feature/[이슈번호]-[짧은-설명]`

---

## hotfix/N-이름

- **프로덕션 긴급 장애 대응**
- main 기준으로 직접 분기
- develop, release를 거치지 않고 main으로 직행
- 완료 후 패치 버전 릴리즈 (v1.1.0 → v1.1.1)

```bash
# main 기준으로 생성
git checkout main
git pull origin main
git checkout -b hotfix/56-payment-failure

# 수정 후 main으로 직접 PR
# PR 제목: [HOTFIX] #56 결제 실패 긴급 수정
```

**네이밍:** `hotfix/[이슈번호]-[문제설명]`

---

## PR 방향 정리

| From | To | 용도 |
|------|----|------|
| `feature/**` | `develop` | 개발 중 테스트 (merge 후 삭제 안 해도 됨) |
| `feature/**` | `release/**` | 테스트 완료 후 릴리즈에 반영 |
| `release/**` | `main` | 릴리즈 배포 |
| `hotfix/**` | `main` | 긴급 패치 배포 |

---

## 브랜치 전체 흐름 예시 (v1.1.0 릴리즈)

```
1. Backlog에서 이슈 #23, #24를 v1.1.0 Milestone에 할당
2. git checkout -b release/v1.1.0 (main 기준)
3. git checkout -b feature/23-darkmode (release/v1.1.0 기준)
4. 개발 완료 → develop merge → 테스트
5. OK → PR: feature/23-darkmode → release/v1.1.0
6. 동일 과정으로 feature/24-notifications
7. 모든 feature merge 완료 → release/v1.1.0 최종 테스트
8. PR: release/v1.1.0 → main
9. git tag v1.1.0 → GitHub Release 생성
```
