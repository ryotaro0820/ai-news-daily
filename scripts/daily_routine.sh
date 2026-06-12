#!/bin/bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

# Load credentials
set -a
source "$PROJECT_DIR/.env"
set +a

DATE=$(TZ=Asia/Tokyo date '+%Y-%m-%d')
NEWS_FILE="$PROJECT_DIR/news/${DATE}-ai-news.md"
LOG_FILE="$PROJECT_DIR/logs/${DATE}.log"
mkdir -p "$PROJECT_DIR/logs"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }

log "=== Daily AI News Routine Started ==="

log "Running Claude news generation..."
/opt/node22/bin/claude --print "$(cat "$PROJECT_DIR/scripts/news_prompt.txt")" \
    >> "$LOG_FILE" 2>&1

if [ -f "$NEWS_FILE" ]; then
    log "Pushing to GitHub..."
    git push github HEAD:main >> "$LOG_FILE" 2>&1
    log "=== Done ==="
else
    log "ERROR: News file not found: $NEWS_FILE"
    exit 1
fi
