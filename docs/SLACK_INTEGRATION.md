# Slack 알림 연동

GitHub Actions로 주요 이벤트를 Slack에 알린다.

## Slack Incoming Webhook 설정

1. Slack → Apps → Incoming Webhooks → Add to Slack
2. 채널 선택 (`#dev-alerts` 권장)
3. Webhook URL 복사
4. GitHub repo → Settings → Secrets → `SLACK_WEBHOOK_URL` 추가

## GitHub Actions 워크플로우

### PR merge 시 알림

`.github/workflows/notify-slack.yml`:

```yaml
name: Slack Notification

on:
  push:
    branches: [main]
  release:
    types: [published]

jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Notify on push to main
        if: github.event_name == 'push'
        uses: slackapi/slack-github-action@v1.26.0
        with:
          payload: |
            {
              "text": "🔀 *${{ github.repository }}* — main 브랜치 업데이트\n커밋: ${{ github.event.head_commit.message }}\n링크: ${{ github.event.head_commit.url }}"
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}

      - name: Notify on release
        if: github.event_name == 'release'
        uses: slackapi/slack-github-action@v1.26.0
        with:
          payload: |
            {
              "text": "🚀 *${{ github.repository }}* — ${{ github.event.release.tag_name }} 릴리즈\n${{ github.event.release.name }}\n${{ github.event.release.html_url }}"
            }
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

## 알림 채널 구성 제안

| 채널 | 알림 내용 |
|------|----------|
| `#dev-deploy` | main push, 릴리즈 |
| `#dev-alerts` | 모니터링 오류, 장애 |
| `#dev-general` | PR merge 등 일반 이벤트 |

채널이 너무 많으면 `#dev` 하나로 통합해도 된다.

## Supabase 장애 알림 (선택)

Supabase Edge Functions + cron으로 헬스체크 후 Slack 알림:

```typescript
// supabase/functions/healthcheck/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

serve(async () => {
  const webhookUrl = Deno.env.get("SLACK_WEBHOOK_URL")!

  try {
    // DB 연결 테스트
    const res = await fetch(`${Deno.env.get("SUPABASE_URL")}/health`)
    if (!res.ok) throw new Error("DB 연결 실패")
  } catch (e) {
    await fetch(webhookUrl, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ text: `🚨 장애 감지: ${e.message}` }),
    })
  }

  return new Response("ok")
})
```
