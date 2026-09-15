#!/usr/bin/env bash
# AI Test 测评笔记本地文档服务管理脚本
# 用法: ./serve.sh start|stop|restart|status|build

PORT=4100
LOG=/tmp/opencode/ai-test-serve.log
PID_FILE=/tmp/opencode/ai-test-serve.pid

start() {
  if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    echo "服务已在运行: http://localhost:$PORT (pid $(cat "$PID_FILE"))"
    return 0
  fi
  nohup honkit serve --port "$PORT" > "$LOG" 2>&1 &
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

build() {
  honkit build && echo "构建产物: _book/"
}

case "$1" in
  start) start ;;
  stop) stop ;;
  restart) stop; start ;;
  status) status ;;
  build) build ;;
  *) echo "用法: ./serve.sh start|stop|restart|status|build" ;;
esac
