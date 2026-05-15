---
description: "[Workflow] 현재 워크플로우 상태 확인 — 어느 단계인지, 다음은 무엇인지"
---

## 역할
언제든 실행해서 현재 워크플로우 상태를 파악한다.

## 실행

`.workflow/state.json` 파일을 읽고 현재 상태를 보여준다.

## state.json 읽기

```bash
cat .workflow/state.json 2>/dev/null || echo "state.json 없음"
```

state.json이 없으면: "아직 릴리즈가 시작되지 않았습니다."

## 출력 형식

```
─────────────────────────────────
Workflow 현재 상태
─────────────────────────────────
현재 릴리즈: v1.0.2
현재 단계:   IMPLEMENT (6/9)
브랜치:      release/v1.0.2
업데이트:    2026-05-16

진행 상황:
  ✅ 요건 수신 (Intake)
  ✅ 요건 분석 (Analysis)
  ✅ 태스크 분리 (Planning)
  ✅ 백로그 등록 (Backlog)
  ✅ 릴리즈 계획 (Release Plan)
  🔄 구현 (Implement)       ← 현재
  ⬜ 테스트 (Test)
  ⬜ 배포 (Deploy)
  ⬜ 모니터링 (Monitor)

이슈 현황:
  완료: #1 스트릭 타임존 버그 수정
  진행 중: #2 리마인더 알림 설정

다음 실행할 커맨드:
  /wf-implement 2   (Issue #2 구현)
  /wf-test          (모든 구현 완료 시)
─────────────────────────────────
```

## Backlog 현황도 함께 표시

```bash
gh issue list --state open --json number,title,milestone,labels
```

Milestone이 없는 이슈 = Backlog 상태로 별도 표시:

```
Backlog (미할당 이슈):
  #3 [FEAT] 홈화면 위젯
  #5 [FIX] 로딩 속도 개선
```

## 아무것도 없을 때

state.json도 없고 진행 중인 릴리즈도 없으면:

```
─────────────────────────────────
진행 중인 릴리즈가 없습니다.

새로운 요건을 접수하려면:  /wf-intake
릴리즈를 시작하려면:      /wf-release-plan [버전]
─────────────────────────────────
```
