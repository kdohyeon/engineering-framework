# 시나리오 검증 결과: v1.0.2 릴리즈

> 검증일: 2026-05-15
> 목적: 프레임워크가 실제 1인 개발자 워크플로우에서 동작하는지 확인

---

## 시나리오 요약

- **앱 상태:** v1.0.1 이미 출시됨
- **요청 수신:** 앱스토어 리뷰 2건, 친구 구두 전달 1건
- **릴리즈 대상:** v1.0.2
- **포함 작업:** BACKLOG-001 (스트릭 버그), BACKLOG-002 (리마인더 알림)
- **보류:** BACKLOG-003 (위젯) → v1.1.0으로 이관

---

## 실행된 흐름

```
1. 앱스토어/친구 요청 → docs/inbox/ 에 원문 그대로 저장
2. Claude와 상의 → 범위 정제, 구현 방향 결정 → BACKLOG_TICKETS.md
3. v1.0.2 Milestone에 BACKLOG-001, 002 할당 결정
4. git checkout main && git checkout -b release/v1.0.2
5. git checkout release/v1.0.2 && git checkout -b feature/backlog-001-streak-timezone-fix
6. 개발 진행 중 엔지니어링 결정 → ADR-001 작성
7. git checkout develop && git merge feature/backlog-001-streak-timezone-fix
   → develop 환경에서 테스트
8. 테스트 OK → PR: feature/* → release/v1.0.2 merge
9. release/v1.0.2 통합 테스트
10. PR: release/v1.0.2 → main merge
11. git tag v1.0.2 && git push origin main --tags
```

---

## git 히스토리 (실제 실행 결과)

```
*   3dd1031 release: v1.0.2                          ← main (v1.0.2 태그)
|\
| * 37f0433 Merge feature/* → release/v1.0.2
|/|
| * 730d22d feat: 스트릭 타임존 버그 수정 (#1)       ← feature 작업
|/
* d94f214 init                                        ← main 초기 상태
```

develop 브랜치는 feature merge 흔적만 있고 main/release에는 영향 없음 → 설계대로 동작.

---

## 검증 결과

| 항목 | 결과 | 비고 |
|------|------|------|
| Inbox 원문 저장 | ✅ | docs/inbox/ 폴더로 관리 |
| Claude 상의 → 정제 | ✅ | BACKLOG_TICKETS.md에 요약 |
| Milestone 할당 후 브랜치 생성 | ✅ | release/* 기준 feature 생성 확인 |
| develop 테스트 후 release merge | ✅ | 흐름 정상 |
| release → main → 태그 | ✅ | v1.0.2 태그 생성 및 push 확인 |
| ADR 작성 (엔지니어링 결정) | ✅ | ADR-001 타임존 처리 방식 |

---

## 프레임워크 보완 사항 (이번 시나리오에서 발견)

### 추가된 개념
- **`docs/REQUESTS_INBOX.md`**: 요청을 해석 없이 원문 그대로 저장하는 개념이 기존 프레임워크에 없었음 → 추가

### 확인된 갭 (추후 개선 여지)
1. **BACKLOG_TICKETS.md 형식**: 현재는 markdown 파일로 관리하지만, GitHub Issues가 실제 단일 소스가 되어야 함. 실제 프로젝트에서는 이 파일 대신 GitHub Issue 직접 사용.
2. **develop 브랜치 재생성 시점 기준**: "테스트가 실패했을 때 develop을 언제 재생성하는가"에 대한 명시적 기준 필요 → feature 브랜치에서 수정 후 재merge가 기본, develop이 심하게 오염됐을 때만 재생성.
3. **BACKLOG-003 이관 기록**: v1.1.0으로 보류된 이슈의 Milestone 변경 이력을 남기는 방법이 명시적이지 않음 → GitHub Issue에서 Milestone만 교체하면 됨, 별도 문서 불필요.
