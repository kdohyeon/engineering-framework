# 이슈 & 마일스톤 관리

## 이슈 레이블 체계

| 레이블 | 색상 | 용도 |
|--------|------|------|
| `feature` | `#0075ca` | 새 기능 |
| `bug` | `#d73a4a` | 버그 리포트 |
| `hotfix` | `#e11d48` | 긴급 수정 (Backlog 스킵) |
| `chore` | `#e4e669` | 환경 설정, 빌드, 의존성 |
| `docs` | `#cfd3d7` | 문서 작업 |
| `wontfix` | `#ffffff` | 대응 안 함 |

---

## 마일스톤 = 릴리즈 버전

각 릴리즈 버전을 Milestone으로 관리한다.
이슈가 Milestone에 할당되는 순간 "이번 버전에 넣기로 결정"된 것이다.

```
Milestone: v1.0.0 (Due: 2026-07-01)  ← MVP
Milestone: v1.1.0 (Due: 2026-08-01)  ← 2차 기능
Milestone: v1.2.0 (Due: 미정)
```

**Milestone이 없는 이슈 = Backlog** (언제 할지 결정 안 됨)

---

## 이슈 제목 컨벤션

```
[FEAT] 기능 이름
[FIX]  버그 설명
[HOTFIX] 긴급 장애 설명
[CHORE] 작업 설명
[DOCS] 문서 설명
```

---

## 이슈 → 브랜치 → PR 연결

1. 이슈 생성 (`feature` 레이블, Milestone 할당)
2. 브랜치 생성: `feature/[이슈번호]-[설명]` (release/** 기준)
3. PR 생성 시 본문에 `Closes #이슈번호` 추가 → merge 시 이슈 자동 Close

```markdown
## 관련 이슈
Closes #23
```

---

## GitHub Projects 칸반 보드

**컬럼 구성:**
```
Backlog → Planned → In Progress → Review → Done
```

| 컬럼 | 기준 |
|------|------|
| Backlog | Milestone 미할당 이슈 |
| Planned | Milestone 할당됨, 아직 개발 시작 전 |
| In Progress | 브랜치 생성 후 개발 중 |
| Review | PR 오픈 상태 |
| Done | PR merge, 이슈 Close |

**자동화 설정 (GitHub Projects):**
- 이슈 생성 → Backlog
- PR 오픈 → In Progress
- PR merge / 이슈 Close → Done

---

## 이슈 작성 습관

- 이슈 하나 = 작업 하나 (하루 이내 완료 가능한 단위)
- 너무 크면 Sub-issues로 분리
- **이슈 만들기 전에 Claude와 먼저 상의** → [Backlog 관리](BACKLOG_MANAGEMENT.md)
- 버그 이슈는 재현 방법 반드시 기록

---

## 커밋에 이슈 번호 연결

커밋 메시지에 이슈 번호를 포함하면 GitHub에서 자동 연결된다.

```bash
git commit -m "feat: 다크 모드 구현 (#23)"
git commit -m "fix: 로그인 크래시 수정 (#34)"
```
