# Solo Dev Framework

1인 개발자를 위한 아이디어 → 출시 → 운영까지의 개발 방법론.

**핵심 원칙:** 도구보다 습관. 프로세스는 가볍게, 기록은 꾸준히.

## 도구 스택

| 역할 | 도구 | 비고 |
|------|------|------|
| 코드 관리 | GitHub | Issues, Projects, Actions, Releases |
| DB / Auth / Storage | Supabase | 무료 티어로 시작 |
| 서버 | Cloud 서버 | VPS / Railway / Fly.io 등 |
| 알림 / 소통 | Slack | Webhook으로 자동화 |
| AI 파트너 | Claude | 기획, 코드리뷰, 문서화 |

## 개발 사이클

```
💡 아이디어 / 버그 발생
    ↓
🤝 Claude와 상의 → 충분히 정제
    ↓
📋 GitHub Issue 생성 → Backlog 등록
    ↓
🎯 Milestone(버전) 할당  ← 릴리즈 계획 시
    ↓
🌿 release/vX.Y.Z 브랜치 생성 (main 기준)
    ↓
🔧 feature/N-이름 브랜치 생성 (release/** 기준)
    ↓
⚙️ 개발 완료 → develop 브랜치 merge → 테스트
    ↓
✅ 테스트 OK → feature/** → release/** merge
    ↓
🧪 release/** 충분히 테스트
    ↓
🚀 release/** → main merge → 배포 (수동)
    ↓
📋 GitHub Release + CHANGELOG 업데이트
```

## 브랜치 역할

| 브랜치 | 역할 | 생성 기준 | 특징 |
|--------|------|----------|------|
| `main` | 프로덕션 (항상 배포 가능) | - | 직접 커밋 금지 |
| `develop` | 통합 테스트용 | main | 임시 브랜치, 언제든 재생성 가능 |
| `release/vX.Y.Z` | 버전별 릴리즈 준비 | main | 릴리즈 단위 브랜치 |
| `feature/N-이름` | 기능 구현 | release/** | 이슈 Milestone 할당 후 생성 |
| `hotfix/N-이름` | 긴급 장애 패치 | main | 패치 버전 릴리즈로 직행 |

## Claude Workflow Commands (`/wf-*`)

개발 전 과정을 Claude slash command로 실행한다.
각 단계는 완료 조건에 따라 자동 또는 사용자 확인으로 다음 단계로 전환된다.

| 커맨드 | 단계 | 전환 조건 |
|--------|------|----------|
| `/wf-intake` | 1. 요건 수신 | auto → analysis |
| `/wf-analysis` | 2. 요건 분석 | user_confirm → planning |
| `/wf-planning` | 3. 태스크 분리 | user_confirm → backlog |
| `/wf-backlog` | 4. 백로그 등록 | auto → waiting |
| `/wf-release-plan [버전]` | 5. 릴리즈 계획 | user_trigger → implement |
| `/wf-implement [이슈번호]` | 6. 구현 | user_confirm → test |
| `/wf-test` | 7. 테스트 | user_confirm → deploy / fail → implement |
| `/wf-deploy` | 8. 배포 | auto → monitor |
| `/wf-monitor` | 9. 모니터링 | auto → intake (새 이슈 시) |
| `/wf-hotfix "증상"` | 긴급 패치 | 1~5단계 스킵, main 직행 |
| `/wf-status` | 상태 확인 | 언제든지 |

→ [워크플로우 상세 설계](workflow/WORKFLOW_DESIGN.md)

## 폴더 구성 (각 프로젝트 repo)

```
my-project/
├── .claude/
│   └── commands/            # Claude /wf-* 커맨드
│       ├── wf-intake.md
│       ├── wf-analysis.md
│       └── ...
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── workflows/
├── .workflow/
│   └── state.json           # 현재 워크플로우 상태 추적
├── docs/
│   ├── inbox/               # 원문 요청 저장소
│   ├── prd/                 # 기획 문서
│   └── decisions/           # ADR
├── CHANGELOG.md
└── README.md
```

## 문서 목록

- [**전체 워크플로우 다이어그램**](docs/WORKFLOW_OVERVIEW.md)
- [아이디어 → PRD 프로세스](docs/IDEA_TO_PRD.md)
- [Backlog 관리 (Claude 상의 → 티켓 등록)](docs/BACKLOG_MANAGEMENT.md)
- [브랜치 전략](docs/BRANCH_STRATEGY.md)
- [이슈 & 마일스톤 관리](docs/ISSUE_MANAGEMENT.md)
- [릴리즈 관리](docs/RELEASE_MANAGEMENT.md)
- [커밋 컨벤션](docs/COMMIT_CONVENTION.md)
- [Slack 알림 연동](docs/SLACK_INTEGRATION.md)

## 새 프로젝트 시작하기

```bash
# 이 repo의 templates 폴더를 새 프로젝트에 복사
./scripts/new-project.sh my-new-app
```
