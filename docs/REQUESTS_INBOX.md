# 요청 수신함 (Requests Inbox)

앱스토어 리뷰, 친구의 구두 전달, 직접 사용 중 발견한 불편함 등
**모든 요청과 요구사항은 해석 없이 받은 그대로 먼저 기록한다.**

## 왜 해석 없이 저장하는가?

- 받은 순간 해석하면 원래 의도가 왜곡될 수 있다
- 나중에 여러 요청을 묶어서 패턴을 볼 수 있다
- Claude와 상의해서 정제하기 전까지는 원문이 기준이다

## 저장 위치

각 프로젝트 repo의 `docs/inbox/` 폴더에 저장한다.

```
docs/
  inbox/
    YYYY-MM-DD-[출처]-[짧은-제목].md
```

**예시:**
```
docs/inbox/2026-05-15-appstore-dark-mode-request.md
docs/inbox/2026-05-20-friend-notification-bug.md
```

## 저장 형식

```markdown
# [받은 날짜] [출처]

## 원문 (그대로)

> (받은 내용을 그대로 붙여넣기. 맞춤법 수정도 하지 않는다)

## 수신 경로

- 앱스토어 리뷰 / 친구 구두 전달 / 직접 사용 중 발견 / 기타

## 처리 상태

- [ ] Inbox 수신
- [ ] Claude 상의 완료
- [ ] GitHub Issue 생성 → #이슈번호
```

## Inbox → Backlog 흐름

```
원문 저장 (inbox/)
    ↓
Claude와 상의 (범위 정제, 구현 방향)
    ↓
GitHub Issue 생성 (정제된 내용으로)
    ↓
inbox 파일에 Issue 번호 기록 후 보관
    ↓
릴리즈 계획 시 → Milestone 할당
```

> inbox 파일은 삭제하지 않는다. 원본 요청의 이력이므로 보관한다.
