# 커밋 컨벤션

Conventional Commits 기반. CHANGELOG 자동 생성을 위해 형식을 지킨다.

## 기본 형식

```
<type>: <설명> (#이슈번호)

[선택] 본문 (줄바꿈 후)

[선택] footer
```

## 타입 목록

| 타입 | 용도 | CHANGELOG 반영 |
|------|------|----------------|
| `feat` | 새 기능 | ✅ Features |
| `fix` | 버그 수정 | ✅ Bug Fixes |
| `hotfix` | 긴급 수정 | ✅ Hotfixes |
| `chore` | 빌드/설정/의존성 | ❌ |
| `docs` | 문서 수정 | ❌ |
| `refactor` | 리팩토링 (기능 변화 없음) | ❌ |
| `style` | 포맷, 세미콜론 등 | ❌ |
| `test` | 테스트 추가/수정 | ❌ |
| `perf` | 성능 개선 | ✅ Performance |

## 예시

```bash
# 기능 추가
git commit -m "feat: 구글 소셜 로그인 추가 (#12)"

# 버그 수정
git commit -m "fix: 로그인 후 홈 화면 크래시 수정 (#34)"

# 긴급 수정
git commit -m "hotfix: 결제 API 오류 긴급 수정 (#56)"

# 환경 설정
git commit -m "chore: ESLint 설정 추가"

# Breaking Change (메이저 버전업)
git commit -m "feat!: API 응답 구조 변경 (#78)

BREAKING CHANGE: user 객체의 id 필드가 userId로 변경됨"
```

## Breaking Change

`!`를 타입 뒤에 붙이면 메이저 버전업 신호.
footer에 `BREAKING CHANGE:` 설명을 추가한다.

## 버전 자동 결정 규칙

| 커밋 | 버전 영향 |
|------|----------|
| `feat!` / `BREAKING CHANGE` | major (1.0.0 → 2.0.0) |
| `feat` | minor (1.0.0 → 1.1.0) |
| `fix`, `hotfix`, `perf` | patch (1.0.0 → 1.0.1) |
| 나머지 | 변화 없음 |
