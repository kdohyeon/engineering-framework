---
description: "[Workflow 6/9] 구현 — feature 브랜치 생성, 개발, develop 테스트, release merge"
---

## 역할
특정 이슈를 feature 브랜치에서 구현하고 release 브랜치에 반영하는 전체 과정을 안내한다.

사용법: `/wf-implement 1`  (이슈 번호)

## 실행

$ARGUMENTS 가 이슈 번호이면 그것을 사용한다.
없으면 `.workflow/state.json`의 pending_issues 중 첫 번째를 사용하거나
사용자에게 번호를 질문한다.

## 1단계: 이슈 내용 확인

```bash
gh issue view [번호]
```

이슈의 제목, 설명, 완료 조건을 출력한다.

## 2단계: feature 브랜치 생성

release 브랜치 기준으로 feature 브랜치를 생성한다:

```bash
# state.json에서 release_branch 읽기
RELEASE_BRANCH=$(cat .workflow/state.json | python3 -c "import sys,json; print(json.load(sys.stdin)['release_branch'])")

git checkout $RELEASE_BRANCH
git pull origin $RELEASE_BRANCH
git checkout -b feature/[이슈번호]-[이슈제목-slug]
```

브랜치 네이밍: `feature/[이슈번호]-[핵심-키워드]`
예: `feature/1-streak-timezone-fix`

## 3단계: 개발 체크리스트 제공

이슈의 완료 조건을 체크리스트로 보여준다:

```
─────────────────────────────────
개발 체크리스트 (Issue #1):
  [ ] 조건 1
  [ ] 조건 2
  [ ] 조건 3

엔지니어링 결정이 필요하면 /wf-implement 실행 중에 ADR을 작성하세요:
  → docs/decisions/ADR-[번호]-[제목].md
─────────────────────────────────
```

## 4단계: develop 브랜치 테스트

개발이 완료됐다고 하면 develop 브랜치에 merge해서 테스트를 안내한다:

```bash
git checkout develop
git merge feature/[브랜치명] --no-ff
```

```
─────────────────────────────────
develop 브랜치에 merge됐습니다.
이제 develop 환경에서 테스트를 진행하세요.

완료 조건을 하나씩 확인해주세요:
  [ ] 조건 1
  [ ] 조건 2

테스트 결과를 알려주세요:
[Y] 테스트 통과 → release에 반영합니다
[N] 버그 발견 → feature 브랜치에서 수정합니다
─────────────────────────────────
```

## 5단계: release 브랜치에 반영

테스트 통과 시 feature → release PR을 생성한다:

```bash
gh pr create \
  --base $RELEASE_BRANCH \
  --head feature/[브랜치명] \
  --title "[FEAT] #[번호] [이슈 제목]" \
  --body "Closes #[번호]"
```

PR이 merge되면 state.json을 업데이트한다:
- `pending_issues`에서 해당 번호 제거
- `completed_issues`에 추가

## 6단계: 다음 이슈 안내

```
─────────────────────────────────
Issue #[번호] 구현 완료 ✓

남은 이슈: #[번호들]

다음 이슈를 구현하려면: /wf-implement [다음 번호]
모든 구현이 완료됐으면: /wf-test
─────────────────────────────────
```

## ADR 작성 트리거

개발 중 아래 상황이면 ADR 작성을 권고한다:
- 두 가지 이상 구현 방법을 고민했을 때
- 외부 라이브러리를 새로 도입할 때
- DB 스키마를 변경할 때
- 기존 아키텍처에 영향을 주는 결정을 할 때

ADR 경로: `docs/decisions/ADR-[번호]-[제목].md`
→ ADR 템플릿: `docs/decisions/` 폴더 참고
