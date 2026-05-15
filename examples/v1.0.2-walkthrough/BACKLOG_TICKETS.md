# Backlog 티켓 목록

> inbox 원문을 Claude와 상의해 정제한 결과물.
> 각 티켓은 GitHub Issue로 생성되며, 아직 Milestone은 미할당 상태.

---

## BACKLOG-001 [FIX] 자정 이후 습관 체크 시 스트릭 카운트 오류

**출처:** `inbox/2026-05-12-friend-streak-bug.md`

**Claude 상의 요약:**
- 현재 스트릭 계산이 UTC 기준으로 되어 있어, 한국 시간 23:00~23:59 체크 시 다음날로 인식될 수 있음
- 해결 방향: 유저의 타임존 기준으로 날짜 계산 로직 수정
- 영향 범위: 스트릭 계산 함수 전반 → 기존 스트릭 데이터에 영향 없음 (계산만 수정)

**완료 조건:**
- [ ] 한국 시간 23:00~23:59에 체크해도 당일 스트릭 유지
- [ ] 기존 유저의 스트릭 기록 변경 없음

**레이블:** `bug`
**GitHub Issue:** #미생성

---

## BACKLOG-002 [FEAT] 습관 리마인더 알림 설정

**출처:** `inbox/2026-05-13-appstore-reminder-notification.md`

**Claude 상의 요약:**
- MVP 범위: 습관별 1일 1회 알림, 시간 직접 설정
- 스코프 밖(이번 버전): 요일별 다른 시간 설정, 스마트 알림
- iOS: UNUserNotificationCenter / Android: WorkManager + NotificationManager 사용
- Supabase에 알림 설정 저장 (user_notification_settings 테이블)

**완료 조건:**
- [ ] 습관별 알림 시간 설정 UI
- [ ] 설정한 시간에 로컬 푸시 알림 발송
- [ ] 알림 on/off 토글

**레이블:** `feature`
**GitHub Issue:** #미생성

---

## BACKLOG-003 [FEAT] 홈화면 위젯 (오늘 습관 달성 현황)

**출처:** `inbox/2026-05-10-appstore-widget-request.md`

**Claude 상의 요약:**
- iOS: WidgetKit (iOS 14+), Android: App Widget
- 난이도 높음. 플랫폼별 별도 구현 필요
- MVP 범위로 줄이면: 오늘 달성한 습관 개수 / 전체 개수만 표시
- 스코프 밖(이번 버전): 잠금화면 위젯 (iOS 16+, 별도 작업)
- 이번 릴리즈보다 다음 마이너 버전(v1.1.0)이 적합할 수 있음

**완료 조건:**
- [ ] 홈화면 소형 위젯: 오늘 달성 N/전체 M 표시
- [ ] 앱과 데이터 동기화 (App Group)

**레이블:** `feature`
**GitHub Issue:** #미생성

---

## v1.0.2 릴리즈 할당 결정

| 티켓 | v1.0.2 포함 여부 | 이유 |
|------|-----------------|------|
| BACKLOG-001 | ✅ 포함 | 버그. 빠른 수정 필요 |
| BACKLOG-002 | ✅ 포함 | 요청 많음. 구현 범위 명확 |
| BACKLOG-003 | ❌ 보류 → v1.1.0 | 난이도 높음. 이번 버전에 무리 |
