#!/usr/bin/env bash
# AI Test 测评笔记构建 / 本地服务脚本
# 用法: ./serve.sh build|build-internal|check|start|stop|restart|status
#
# 线上（对外）：https://aitest.zingzheng.de5.net/
#   - 由 nginx 直接托管本目录的 _book（vhost: /etc/nginx/sites-available/aitest）
#   - 内容更新：跑 `./serve.sh build`，nginx 自动生效，无需 reload
#   - 公开版 = SUMMARY.md 所列出的一切；内部文档（README 需求说明书、附录 E）不在其中
#
# 本脚本的 start/stop：仅用于本机预览 http://localhost:4100（未对公网放行）

set -uo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PORT=4100
LOG=/tmp/opencode/ai-test-serve.log
PID_FILE=/tmp/opencode/ai-test-serve.pid

# 公开内容禁止出现的关键词（内部/私人信息）
FORBIDDEN='申申|Zing|岗位 JD|岗位要求|面试|REQUIREMENTS|拍板|待确认|需求说明书'

# 可选：本机专属过滤词（如源站 IP、本地绝对路径），每行一条
# 该文件不入库（已加入 .git/info/exclude），避免把生产信息带进公开仓库
if [ -f "$ROOT/.check-extra" ]; then
  FORBIDDEN="$FORBIDDEN|$(grep -v '^[[:space:]]*$' "$ROOT/.check-extra" | paste -sd '|' -)"
fi

# 收集公开 SUMMARY 实际引用的文件清单
public_files() {
  grep -oE '\]\([^)]+\)' "$ROOT/SUMMARY.md" \
    | sed -E 's/^\]\(//; s/\)$//' \
    | while read -r p; do
        [ -f "$ROOT/$p" ] && echo "$ROOT/$p"
      done
}

# 构建前：检查源文件
check() {
  local hits
  hits=$(public_files | xargs -r grep -nHE "$FORBIDDEN" 2>/dev/null || true)
  hits="$hits$(grep -nHE "$FORBIDDEN" "$ROOT/book.json" 2>/dev/null || true)"
  if [ -n "$(echo "$hits" | tr -d '[:space:]')" ]; then
    echo "❌ 公开内容检查未通过，发现内部/私人内容："
    echo "$hits"
    return 1
  fi
  echo "✅ 公开内容检查通过（源文件）"
}

# 构建后：检查产物，防止渲染环节带入或 .bookignore 失效
check_built() {
  local bad="" hits
  # 1) 内部文件一旦出现在产物路径中，直接判失败（兜底 .bookignore）
  for p in "docs/REQUIREMENTS.md" "docs/research" "docs/notes/appendix/E-career-map.md" "SUMMARY-internal.md" "serve.sh"; do
    [ -e "$ROOT/_book/$p" ] && bad="$bad\n  _book/$p"
  done
  # 2) 关键词扫描
  hits=$(grep -rlE "$FORBIDDEN" "$ROOT/_book" 2>/dev/null || true)
  if [ -n "$bad" ] || [ -n "$hits" ]; then
    echo "❌ 构建产物检查未通过："
    [ -n "$bad" ] && echo -e "$bad"
    [ -n "$hits" ] && echo "$hits"
    return 1
  fi
  echo "✅ 公开内容检查通过（构建产物）"
}

build() {
  check || return 1
  rm -rf "$ROOT/_book"
  honkit build "$ROOT" "$ROOT/_book" || return 1
  check_built || return 1
  echo "构建产物: _book/（公开版）"
}

# 内部版：临时换用内部 SUMMARY，并暂时移开 .bookignore（否则内部文档也会被排除）
build_internal() {
  cp "$ROOT/SUMMARY.md" /tmp/opencode/summary-public.bak
  [ -f "$ROOT/.bookignore" ] && mv "$ROOT/.bookignore" /tmp/opencode/bookignore.bak
  cp "$ROOT/SUMMARY-internal.md" "$ROOT/SUMMARY.md"
  honkit build "$ROOT" "$ROOT/_book-internal"
  mv /tmp/opencode/summary-public.bak "$ROOT/SUMMARY.md"
  [ -f /tmp/opencode/bookignore.bak ] && mv /tmp/opencode/bookignore.bak "$ROOT/.bookignore"
  echo "构建产物: _book-internal/（内部版，勿公开）"
}

start() {
  if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    echo "服务已在运行: http://localhost:$PORT (pid $(cat "$PID_FILE"))"
    return 0
  fi
  nohup honkit serve "$ROOT" --port "$PORT" > "$LOG" 2>&1 &
  echo $! > "$PID_FILE"
  sleep 4
  echo "服务已启动: http://localhost:$PORT"
}

stop() {
  if [ -f "$PID_FILE" ]; then
    kill "$(cat "$PID_FILE")" 2>/dev/null && rm -f "$PID_FILE"
    echo "服务已停止"
  else
    echo "服务未在运行"
  fi
}

status() {
  if curl -s -o /dev/null "http://localhost:$PORT"; then
    echo "服务运行中: http://localhost:$PORT"
  else
    echo "服务未运行"
  fi
}

case "${1:-}" in
  build) build ;;
  build-internal) build_internal ;;
  check) check ;;
  start) start ;;
  stop) stop ;;
  restart) stop; start ;;
  status) status ;;
  *) echo "用法: ./serve.sh build|build-internal|check|start|stop|restart|status" ;;
esac
