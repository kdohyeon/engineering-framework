#!/bin/bash
# 새 프로젝트에 이 프레임워크 템플릿을 적용하는 스크립트
#
# 사용법: ./scripts/new-project.sh <프로젝트-경로>
# 예시:   ./scripts/new-project.sh ~/IdeaProjects/my-new-app

set -e

FRAMEWORK_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$1"

if [ -z "$TARGET_DIR" ]; then
  echo "사용법: $0 <프로젝트-경로>"
  exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
  echo "오류: 디렉토리가 존재하지 않습니다: $TARGET_DIR"
  echo "먼저 프로젝트 디렉토리를 만들어주세요."
  exit 1
fi

echo "프레임워크 템플릿 적용 중..."
echo "   소스: $FRAMEWORK_DIR/templates"
echo "   대상: $TARGET_DIR"
echo ""

# .github 폴더
mkdir -p "$TARGET_DIR/.github/ISSUE_TEMPLATE"
mkdir -p "$TARGET_DIR/.github/workflows"

cp "$FRAMEWORK_DIR/templates/github/ISSUE_TEMPLATE/feature.md" \
   "$TARGET_DIR/.github/ISSUE_TEMPLATE/feature.md"
echo "ok .github/ISSUE_TEMPLATE/feature.md"

cp "$FRAMEWORK_DIR/templates/github/ISSUE_TEMPLATE/bug.md" \
   "$TARGET_DIR/.github/ISSUE_TEMPLATE/bug.md"
echo "ok .github/ISSUE_TEMPLATE/bug.md"

cp "$FRAMEWORK_DIR/templates/github/PULL_REQUEST_TEMPLATE.md" \
   "$TARGET_DIR/.github/PULL_REQUEST_TEMPLATE.md"
echo "ok .github/PULL_REQUEST_TEMPLATE.md"

cp "$FRAMEWORK_DIR/templates/github/workflows/notify-slack.yml" \
   "$TARGET_DIR/.github/workflows/notify-slack.yml"
echo "ok .github/workflows/notify-slack.yml"

# Claude 워크플로우 커맨드
mkdir -p "$TARGET_DIR/.claude/commands"
cp "$FRAMEWORK_DIR/templates/claude/commands"/wf-*.md \
   "$TARGET_DIR/.claude/commands/"
echo "ok .claude/commands/ (wf-* 커맨드 11개)"

# docs 폴더
mkdir -p "$TARGET_DIR/docs/prd"
mkdir -p "$TARGET_DIR/docs/decisions"
mkdir -p "$TARGET_DIR/docs/inbox"
echo "ok docs/prd/ docs/decisions/ docs/inbox/ 폴더 생성"

# .workflow 폴더 (워크플로우 상태 추적)
mkdir -p "$TARGET_DIR/.workflow"
cat > "$TARGET_DIR/.workflow/state.json" <<'EOF'
{
  "current_release": null,
  "release_branch": null,
  "stage": "idle",
  "pending_issues": [],
  "completed_issues": [],
  "last_updated": null
}
EOF
echo "ok .workflow/state.json"

# .gitignore에 .workflow 제외 안 함 (이력 관리 목적으로 커밋)

# CHANGELOG.md (없을 때만 생성)
if [ ! -f "$TARGET_DIR/CHANGELOG.md" ]; then
  cp "$FRAMEWORK_DIR/templates/CHANGELOG.md" "$TARGET_DIR/CHANGELOG.md"
  echo "ok CHANGELOG.md"
fi

echo ""
echo "완료! 다음 단계:"
echo ""
echo "1. GitHub repo 생성 후 push"
echo ""
echo "2. GitHub Secrets 설정:"
echo "   - SLACK_WEBHOOK_URL"
echo ""
echo "3. GitHub Issues 레이블 추가:"
echo "   feature / bug / hotfix / chore / docs"
echo ""
echo "4. Claude Code에서 워크플로우 시작:"
echo "   /wf-status     현재 상태 확인"
echo "   /wf-intake     새 요건 접수"
echo "   /wf-release-plan v1.0.0   첫 릴리즈 시작"
