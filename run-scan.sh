#!/bin/bash
# run-scan.sh — Unified runner for MCP Site Scanner
# Usage:
#   ./run-scan.sh api               # run as Flask API server
#   ./run-scan.sh cli URL           # run CLI interactive scan
#   ./run-scan.sh once URL          # one-off scan (exits after report)
#   ./run-scan.sh help              # show this help

APP="mcp_site_scanner.py"
VENV_DIR=".venv"

# Ensure script runs from its own directory
cd "$(dirname "$0")" || exit 1

# Check Python environment
if [ ! -d "$VENV_DIR" ]; then
  echo "🔧 Creating virtual environment..."
  python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

# Install dependencies if needed
if [ ! -f "requirements.txt" ]; then
  echo "❌ Missing requirements.txt — creating default one..."
  cat <<EOF > requirements.txt
flask
requests
beautifulsoup4
lxml
PyYAML
EOF
fi

echo "📦 Installing dependencies..."
pip install -r requirements.txt > /dev/null

# Command handling
MODE="$1"
URL="$2"

if [ "$MODE" == "api" ]; then
  echo "🚀 Starting MCP Site Scanner API server on port 8020..."
  python "$APP" --host 0.0.0.0 --port 8020

elif [ "$MODE" == "cli" ]; then
  if [ -z "$URL" ]; then
    echo "❌ Missing URL. Example: ./run-scan.sh cli https://example.com"
    exit 1
  fi
  echo "🔍 Running interactive CLI scan on $URL"
  python "$APP" --target "$URL"

elif [ "$MODE" == "once" ]; then
  if [ -z "$URL" ]; then
    echo "❌ Missing URL. Example: ./run-scan.sh once https://example.com"
    exit 1
  fi
  echo "⚡ Running one-off scan on $URL"
  python "$APP" --target "$URL" --once

else
  echo "Usage:"
  echo "  ./run-scan.sh api               # run API server"
  echo "  ./run-scan.sh cli <URL>         # run interactive CLI scan"
  echo "  ./run-scan.sh once <URL>        # run one-off scan and exit"
  echo "  ./run-scan.sh help              # show this help"
  exit 0
fi
