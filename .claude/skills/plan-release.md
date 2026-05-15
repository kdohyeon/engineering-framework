---
name: plan-release
description: 릴리즈 계획을 수립한다. backlog의 ready 항목을 보여주고, 포함할 항목 선택 후 브랜치를 생성. 트리거: "릴리즈 계획하자", "다음 릴리즈", "/plan-release"
---

# Plan Release — 릴리즈 계획 수립

## 프로세스

1. **현재 state 확인**: `.workflow/state.md` 를 읽는다. `status`가 `planning` 또는 `done`이 아니면 "현재 진행 중인 릴리즈가 있습니다: vX.Y.Z (status)" 라고 알리고 계속할지 물어본다.

2. **backlog 목록 표시**: `backlog/` 디렉토리에서 `status: ready` 인 파일들을 읽어 목록으로 보여준다:
   ```
   Ready 항목:
   - 001: 사용자 로그인 개선 [high]
   - 003: 결제 버그 픽스 [high]
   - 005: 대시보드 신기능 [medium]
   ```
   ready 항목이 없으면 "backlog에 ready 항목이 없습니다. /intake 로 요건을 먼저 추가해주세요." 라고 알린다.

3. **포함 항목 선택**: 어떤 항목을 이번 릴리즈에 포함할지 사용자에게 물어본다.

4. **버전 번호 결정**:
   - 선택된 항목들의 type을 보고 SemVer 추천:
     - bug만 있으면: PATCH 증가 추천 (예: v1.0.1)
     - feature 있으면: MINOR 증가 추천 (예: v1.1.0)
     - breaking change 언급되면: MAJOR 증가 추천 (예: v2.0.0)
   - "v1.1.0 을 추천합니다. 다른 버전을 원하시면 말씀해주세요." 라고 제안.
   - 사용자가 최종 확인.

5. **파일 생성**: `releases/vX.Y.Z/plan.md` 생성:

```markdown
---
version: vX.Y.Z
status: in-progress
started: YYYY-MM-DD
---

# Release vX.Y.Z Plan

## 포함 항목
- [001] 사용자 로그인 개선 (feature)
- [003] 결제 버그 픽스 (bug)

## 목표
(선택된 항목들의 배경을 요약)
```

6. **state.md 업데이트**: `.workflow/state.md` 를 업데이트:
```
# Workflow State

release: vX.Y.Z
status: in-progress
started: YYYY-MM-DD
tasks:
  # 아직 feature 브랜치 없음. /start-feature 로 시작.
```

7. **backlog 파일 업데이트**: 선택된 항목들의 `release` 필드를 `vX.Y.Z` 로, `status` 를 `in-progress` 로 업데이트.

8. **브랜치 생성**: main에서 3개 브랜치 생성:
```bash
git checkout main
git checkout -b release/vX.Y.Z
git push origin release/vX.Y.Z
git checkout main
git checkout -b dev/vX.Y.Z
git push origin dev/vX.Y.Z
git checkout main
git checkout -b test/vX.Y.Z
git push origin test/vX.Y.Z
git checkout dev/vX.Y.Z
```

9. **완료 알림**: 생성된 파일, 업데이트된 backlog, 생성된 브랜치 목록을 사용자에게 알린다.

## 주의사항
- git 명령어 실행 전 현재 브랜치가 main인지 확인. 아니면 `git checkout main` 먼저.
- GitLab remote가 없는 프로젝트면 push 생략 (경고만 표시).
