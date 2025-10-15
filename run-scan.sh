#!/bin/bash
# =============================================================================
# SCRIPT: run-scan.sh
# PURPOSE: Orchestrates the MCP Site Scanner (CLI, API, One-Off).
# -----------------------------------------------------------------------------
# AUTHOR: Mojo Consultants DevOps
# VERSION: 1.2
# =============================================================================
# 📖  DEVELOPER NOTES — READ LIKE SCRIPTURE
# 1. Every variable is a vessel — it names its purpose.
# 2. Every section declares its intent in plain terms.
# 3. This script ensures a report is always born after a scan.
# 4. Logs speak the truth of each run; they are never silenced.
# =============================================================================

# ─────────────────────────────────────────────────────────────────────────────
#  DECLARATIONS: Paths and constants
# ─────────────────────────────────────────────────────────────────────────────
APP="mcp_site_scanner.py"       # the core Python engine that does the scan
VENV_DIR=".venv"                # the local Python virtual environment
LOG_DIR="logs"                  # folder where run logs are written
REPORT_DIR="reports"            # folder where HTML reports live
LOG_FILE="$LOG_DIR/scan_$(date +%Y%m%d_%H%M%S).log"  # unique timestamped log
MODE="$1"                       # first argument: 'api' | 'cli' | 'once' | 'test'
TARGET_URL="$2"                 # second argument: URL to scan
START_TIME=$(date +%s)          # time the script began
mkdir -p "$LOG_DIR" "$REPORT_DIR"

# ─────────────────────────────────────────────────────────────────────────────
#  FUNCTION: log_and_print
#  PURPOSE: echo a line both to terminal and log file
# ─────────────────────────────────────────────────────────────────────────────
log_and_print() {
  echo "$1" | tee -a "$LOG_FILE"
}

# ─────────────────────────────────────────────────────────────────────────────
#  STEP 1: Move to script directory
# ─────────────────────────────────────────────────────────────────────────────
cd "$(dirname "$0")" || exit 1

# ─────────────────────────────────────────────────────────────────────────────
#  STEP 2: Prepare environment (virtualenv + dependencies)
# ─────────────────────────────────────────────────────────────────────────────
if [ ! -d "$VENV_DIR" ]; then
  log_and_print "🔧 Creating virtual environment..."
  python3 -m venv "$VENV_DIR"
fi

# Activate the environment (holy ground)
source "$VENV_DIR/bin/activate"

# Ensure requirements exist; if missing, create with canonical dependencies.
if [ ! -f "requirements.txt" ]; then
  log_and_print "⚠️  No requirements.txt found — creating default one."
  cat <<EOF > requirements.txt
flask
requests
beautifulsoup4
lxml
PyYAML
behave
pytest
EOF
fi

# Install dependencies quietly but faithfully.
log_and_print "📦 Installing dependencies..."
pip install -r requirements.txt > /dev/null

# ─────────────────────────────────────────────────────────────────────────────
#  STEP 3: Mode Logic — determine how the scanner should serve
# ─────────────────────────────────────────────────────────────────────────────
if [ "$MODE" == "api" ]; then
  # 🕊️ API MODE — Starts the Flask tool server (MCP endpoint)
  log_and_print "🚀 Starting MCP Site Scanner API server on port 8020..."
  python "$APP" --host 0.0.0.0 --port 8020 2>&1 | tee -a "$LOG_FILE"

elif [ "$MODE" == "cli" ]; then
  # ⚙️ CLI MODE — Runs the scanner interactively, showing results live
  if [ -z "$TARGET_URL" ]; then
    log_and_print "❌ Missing URL. Usage: ./run-scan.sh cli https://example.com"
    exit 1
  fi

  log_and_print "🔍 Beginning interactive scan on: $TARGET_URL"
  python "$APP" --target "$TARGET_URL" 2>&1 | tee -a "$LOG_FILE"

  # Guarantee the report is produced after the run.
  if [ -f "$REPORT_DIR/report.html" ]; then
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    log_and_print "✅ Scan completed for: $TARGET_URL"
    log_and_print "🕒 Duration: ${DURATION}s"
    log_and_print "📄 Report available at: $REPORT_DIR/report.html"
    log_and_print "📘 Log file: $LOG_FILE"
  else
    log_and_print "⚠️  No report found. Something went astray."
    exit 1
  fi

elif [ "$MODE" == "once" ]; then
  # ⚡ ONE-OFF MODE — Runs one scan then exits
  if [ -z "$TARGET_URL" ]; then
    log_and_print "❌ Missing URL. Usage: ./run-scan.sh once https://example.com"
    exit 1
  fi

  log_and_print "⚡ Performing one-off scan on: $TARGET_URL"
  python "$APP" --target "$TARGET_URL" --once 2>&1 | tee -a "$LOG_FILE"

  # Ensure report exists
  if [ -f "$REPORT_DIR/report.html" ]; then
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    log_and_print "✅ One-off scan finished for: $TARGET_URL"
    log_and_print "🕒 Time spent: ${DURATION}s"
    log_and_print "📄 Report generated: $REPORT_DIR/report.html"
  else
    log_and_print "❌ No report generated. Verify Python output for errors."
    exit 1
  fi

elif [ "$MODE" == "test" ]; then
  # 🧪 TEST MODE — Run cucumber (behave) and unit tests
  log_and_print "🧪 Running all cucumber (behave) and unit tests..."
  behave tests/features 2>&1 | tee -a "$LOG_FILE"
  pytest tests/unit 2>&1 | tee -a "$LOG_FILE"
  log_and_print "✅ Tests completed. See log for details: $LOG_FILE"

else
  # 🗒️ HELP MODE — Display usage guide
  log_and_print "Usage:"
  echo "  ./run-scan.sh api               # Run API server" | tee -a "$LOG_FILE"
  echo "  ./run-scan.sh cli <URL>         # Run interactive CLI scan" | tee -a "$LOG_FILE"
  echo "  ./run-scan.sh once <URL>        # Run one-off scan and exit" | tee -a "$LOG_FILE"
  echo "  ./run-scan.sh test              # Run tests (cucumber + unit)" | tee -a "$LOG_FILE"
  exit 0
fi
