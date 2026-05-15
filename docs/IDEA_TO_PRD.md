# 아이디어 → PRD 프로세스

새 아이디어가 생겼을 때, 바로 코딩하지 말고 Claude와 먼저 충분히 탐색한다.

## 1단계: 아이디어 탐색 (Claude와 대화)

아래 질문들을 Claude와 함께 답하면서 아이디어를 구체화한다.

```
1. 이 앱/서비스는 어떤 문제를 해결하는가?
2. 누가 쓰는가? (타겟 유저)
3. 핵심 가치는 무엇인가? (한 문장으로)
4. 비슷한 서비스는 무엇이고, 어떻게 다른가?
5. MVP에 꼭 필요한 기능 3가지는?
6. 수익 모델은? (무료/유료/광고)
7. 기술 스택은 무엇을 쓸 것인가?
8. 1인 개발자로 현실적인 타임라인은?
```

## 2단계: PRD 작성

탐색 후 `docs/prd/v1.0.md` 파일을 생성한다.
→ [PRD 템플릿](../templates/PRD_TEMPLATE.md) 참고

**저장 경로 규칙:**
- 최초 기획: `docs/prd/v1.0.md`
- 기능 추가 기획: `docs/prd/v1.1.md`, `v2.0.md` 등

## 3단계: 기술 스펙 확정

PRD를 바탕으로 아래를 결정한다.

```markdown
## 기술 결정 사항
- 플랫폼: Web / iOS / Android / 크로스플랫폼
- 프론트: React / Next.js / Flutter / SwiftUI
- 백엔드: Supabase (BaaS) / Express / FastAPI
- DB: Supabase PostgreSQL
- 인증: Supabase Auth
- 스토리지: Supabase Storage
- 배포: (결정 필요)
- 모니터링: (결정 필요)
```

아키텍처 결정이 중요하다면 `docs/decisions/ADR-001-tech-stack.md`에 기록한다.
→ [ADR 템플릿](../templates/ADR_TEMPLATE.md) 참고

## 4단계: GitHub Issues 생성

PRD의 기능 목록을 GitHub Issues로 변환한다.

```
[FEAT] 회원가입 / 로그인 구현       → label: feature
[FEAT] 메인 화면 UI 구현            → label: feature
[FEAT] 데이터 저장 및 불러오기       → label: feature
[CHORE] 프로젝트 초기 세팅          → label: chore
```

Milestone을 `v1.0.0`으로 설정하고 Issues를 연결한다.

## 체크리스트

```
[ ] 아이디어 탐색 완료 (Claude 대화)
[ ] PRD 작성 완료 (docs/prd/v1.0.md)
[ ] 기술 스택 결정
[ ] GitHub repo 생성
[ ] GitHub Milestone 생성 (v1.0.0)
[ ] GitHub Issues 생성
[ ] 개발 시작
```
