# Dev Workflow 설계

개발 프레임워크 전체를 **상태 머신(State Machine)** 으로 구현한다.
각 단계(Stage)는 Claude slash command(`/wf-*`)로 실행되고,
완료 조건에 따라 자동 또는 사용자 확인을 통해 다음 단계로 전환된다.

---

## 전체 구조

```
                        [신규 요건/요청]
                               │
                    ┌──────────▼──────────┐
            ┌──────►│  1. INTAKE          │  /wf-intake
            │       │  원문 그대로 저장    │
            │       └──────────┬──────────┘
            │                  │ auto
            │       ┌──────────▼──────────┐
            │       │  2. ANALYSIS        │  /wf-analysis
            │       │  요건 분석           │
            │       └──────┬───────┬──────┘
            │         confirm│     │reject
            │       ┌───────▼──┐   └────►(intake로 재수집)
            │       │3. PLAN   │  /wf-planning
            │       │태스크 분리│
            │       └──────┬───┘
            │          confirm│
            │       ┌───────▼──────────────┐
            │       │  4. BACKLOG          │  /wf-backlog
            │       │  GitHub Issues 등록   │
            │       └──────────┬───────────┘
            │                  │ auto
            │       ┌──────────▼──────────┐
            │       │  5. WAITING         │
            │       │  릴리즈 계획까지 대기 │
            │       └──────────┬──────────┘
            │                  │ user trigger
            │       ┌──────────▼──────────┐
            │       │  6. RELEASE PLAN    │  /wf-release-plan
            │       │  버전, 브랜치 계획   │
            │       └──────────┬──────────┘
            │                  │ auto
            │       ┌──────────▼──────────┐
            │  ◄────┤  7. IMPLEMENT       │  /wf-implement
            │(다음   │  feature/** 개발    │
            │ 기능)  └────┬──────────┬────┘
            │         done│          │bug
            │       ┌─────▼──┐   ┌───▼──────────┐
            │       │8. TEST │   │ re-implement  │
            │       │통합테스트│  └──────────────►│
            │       └───┬─┬──┘                  │
            │       pass│ │fail                 │
            │      ┌────▼─┤ └──────────────────►┘
            │      │9.DEPLOY│  /wf-deploy
            │      │배포    │
            │      └────┬───┘
            │           │ auto
            │      ┌────▼──────┐
            └──────┤10. MONITOR│  /wf-monitor
            (새이슈) │모니터링   │
                   └───────────┘


  [긴급 장애]
       │
  /wf-hotfix ──► hotfix/** → main → DEPLOY → MONITOR
  (1~5단계 스킵)
```

---

## 트랙 구분

| 트랙 | 단계 | 단위 |
|------|------|------|
| **Issue Track** | Intake → Analysis → Planning → Backlog | 이슈/요건 하나 |
| **Release Track** | Release Plan → Implement → Test → Deploy → Monitor | 릴리즈 하나 |

하나의 릴리즈는 여러 이슈를 포함한다.

---

## 전환 조건 유형

| 유형 | 설명 | 예시 |
|------|------|------|
| `auto` | 현재 단계 완료 시 자동 전환 | intake → analysis |
| `user_confirm` | 사용자가 명시적으로 확인해야 전환 | analysis → planning |
| `user_trigger` | 사용자가 직접 다음 커맨드를 실행 | waiting → release_plan |
| `conditional` | 결과에 따라 다른 단계로 분기 | test pass/fail |

---

## Workflow 상태 추적

각 프로젝트 루트에 `.workflow/state.json`을 두어 현재 상태를 추적한다.

```json
{
  "current_release": "v1.0.2",
  "release_branch": "release/v1.0.2",
  "stage": "implement",
  "pending_issues": [1, 2],
  "completed_issues": [3],
  "last_updated": "2026-05-16"
}
```

`/wf-status`로 현재 상태를 언제든 확인할 수 있다.

---

## 파일 구조

```
my-project/
├── .workflow/
│   └── state.json        ← 현재 워크플로우 상태
├── .claude/
│   └── commands/         ← Claude slash commands
│       ├── wf-intake.md
│       ├── wf-analysis.md
│       └── ...
└── docs/
    └── inbox/            ← 원문 요청 저장소
```

---

## 커맨드 목록

| 커맨드 | 단계 | 트리거 |
|--------|------|--------|
| `/wf-intake` | 요건 수신 | 사용자 |
| `/wf-analysis` | 요건 분석 | 사용자 (이전 단계 완료 후) |
| `/wf-planning` | 태스크 분리 | 사용자 확인 후 |
| `/wf-backlog` | 백로그 등록 | 사용자 확인 후 |
| `/wf-release-plan` | 릴리즈 계획 | 사용자 (릴리즈 결정 시) |
| `/wf-implement` | 구현 | 자동 (release plan 완료 후) |
| `/wf-test` | 테스트 | 사용자 (구현 완료 후) |
| `/wf-deploy` | 배포 | 사용자 확인 후 |
| `/wf-monitor` | 모니터링 | 자동 (배포 후) |
| `/wf-hotfix` | 긴급 패치 | 사용자 (장애 발생 시) |
| `/wf-status` | 상태 확인 | 언제든지 |
