# Backlog 관리

새 기능이나 버그가 생겼을 때, 바로 이슈를 만들지 않는다.
**Claude와 먼저 충분히 상의해서 정제한 뒤** GitHub Issue로 등록한다.

---

## 왜 Claude와 먼저 상의하는가?

- 아이디어가 처음엔 막연하거나 방향이 틀릴 수 있다
- 기술적으로 더 나은 구현 방법이 있을 수 있다
- 범위가 너무 크거나 너무 작을 수 있다
- 의존 관계나 부작용을 미리 파악할 수 있다

이슈는 한 번 만들면 이력이 남는다. 충분히 생각한 뒤에 만드는 게 낫다.

---

## 1단계: Claude와 상의

새 기능 아이디어나 버그가 생기면 Claude에게 아래 내용을 던진다.

**기능 아이디어일 때:**
```
이런 기능을 추가하려고 해: [아이디어 설명]
- 어떤 문제를 해결하는지 같이 정리해줘
- MVP 범위로 줄이면 어떻게 되는지
- 기술적으로 어떻게 구현하면 좋을지
- 주의할 점이나 리스크가 있는지
```

**버그일 때:**
```
이런 버그가 있어: [증상 설명]
- 원인이 뭔지 같이 추론해줘
- 수정 방법 여러 가지를 비교해줘
- 어떤 방법이 side effect가 적은지
```

---

## 2단계: GitHub Issue 등록 (Backlog)

상의가 끝나면 정제된 내용으로 이슈를 만든다.

**이슈 상태:** `Backlog` (Milestone 미할당)
**레이블:** `feature` 또는 `bug`

이슈 제목과 본문은 `.github/ISSUE_TEMPLATE/`을 사용한다.

> Backlog에 쌓인 이슈는 아직 **언제 할지 결정되지 않은 상태**다.
> Milestone이 없으면 특정 버전에 포함되지 않는다.

---

## 3단계: Milestone 할당 (릴리즈 계획 시)

릴리즈를 계획할 때 Backlog에서 이슈를 꺼내 Milestone에 할당한다.  
선정 기준, 버전 결정, 롤백 전략, 모니터링 계획은 → [RELEASE_PLANNING.md](RELEASE_PLANNING.md)

```
Backlog 이슈 목록 검토 (RELEASE_PLANNING.md Step 1-2 수행)
    ↓
이번 릴리즈(v1.1.0)에 넣을 것들 선택
    ↓
해당 이슈에 Milestone: v1.1.0 설정
    ↓
release/v1.1.0 브랜치 생성 (없으면)
    ↓
feature/N-이름 브랜치 생성 (release/v1.1.0 기준)
    ↓
개발 시작
```

**Milestone = 이 기능이 들어갈 버전** 이라는 명시적 약속이다.

---

## Backlog 이슈 상태 흐름

```
[Backlog]  →  [Milestone 할당]  →  [In Progress]  →  [Done]
  (미할당)      (버전 결정)         (브랜치 생성,       (PR merge,
                                    개발 중)            이슈 Close)
```

GitHub Projects 칸반 보드 컬럼:
```
Backlog | Planned (Milestone 할당) | In Progress | Done
```

---

## 이슈 크기 가이드

이슈 하나는 feature 브랜치 하나에 대응된다.
**하루 이내에 완료할 수 있는 단위**가 이상적이다.

너무 크면 Claude와 상의해서 Sub-issues로 분리:
```
[FEAT] 소셜 로그인 구현  ← 너무 큼
  ↓ 분리
[FEAT] 구글 OAuth 연동
[FEAT] 로그인 후 리다이렉트 처리
[FEAT] 소셜 계정 프로필 연동
```

---

## 빠른 참고

| 상황 | 행동 |
|------|------|
| 아이디어 생김 | Claude 상의 → Issue 생성 → Backlog |
| 버그 발견 | Claude 원인 분석 → Issue 생성 → Backlog |
| 긴급 장애 | Issue 생성 → hotfix 브랜치 직접 (Backlog 스킵) |
| 릴리즈 계획 | Backlog에서 선택 → Milestone 할당 → 개발 시작 |
