---
name: nxe-finish-release
description: QA 완료 후 릴리즈를 마무리한다. test→release 머지, 릴리즈 노트 작성, release→main 머지, 태그 생성, GitLab push까지 수행. 트리거: "릴리즈하자", "테스트 완료", "/finish-release"
---

# Finish Release — 릴리즈 마무리

## 프로세스

1. **state.md 확인**: 현재 릴리즈 버전(vX.Y.Z)을 확인한다. status가 `in-progress` 또는 `testing` 이어야 한다.

2. **최종 확인**: "vX.Y.Z 릴리즈를 마무리합니다. test/vX.Y.Z 브랜치의 모든 QA가 완료됐나요? (yes/no)" 라고 물어본다.

3. **릴리즈 노트 작성**: `releases/vX.Y.Z/plan.md` 와 포함된 backlog 파일들을 읽어 `releases/vX.Y.Z/release-note.md` 를 생성:

```markdown
# Release vX.Y.Z

**릴리즈 날짜:** YYYY-MM-DD

## 변경 사항

### 새 기능
- 001: 사용자 로그인 개선 — (한 줄 설명)

### 버그 수정
- 003: 결제 버그 픽스 — (한 줄 설명)

## 영향 범위
(영향받는 모듈/화면 요약)

## 배포 주의사항
(있으면 작성, 없으면 "없음")
```

4. **test → release 머지**:
```bash
git checkout release/vX.Y.Z
git merge test/vX.Y.Z --no-ff -m "merge: test/vX.Y.Z into release/vX.Y.Z"
```

5. **release → main 머지 + 태그**:
```bash
git checkout main
git merge release/vX.Y.Z --no-ff -m "release: vX.Y.Z"
git tag -a vX.Y.Z -m "Release vX.Y.Z"
```

6. **backlog 파일 done 처리**: 이번 릴리즈에 포함된 모든 backlog 파일의 `status` 를 `done` 으로 업데이트.

7. **state.md 완료 처리**:
```
# Workflow State

release: vX.Y.Z
status: done
started: YYYY-MM-DD
finished: YYYY-MM-DD
tasks:
  - NNN-title (feature/NNN-title, done)
```

8. **GitLab push**:
```bash
git push origin main
git push origin vX.Y.Z
git push origin release/vX.Y.Z
```

9. **완료 알림**: 릴리즈 노트 경로, 태그, push 완료 내용을 알린다. "배포는 직접 진행해주세요." 라고 안내한다.

## 주의사항
- main push 전 반드시 사용자에게 한 번 더 확인을 받는다.
- `git push origin vX.Y.Z` 는 태그 push (브랜치 아님).
- GitLab remote가 없는 프로젝트면 push 생략 (경고만 표시).
