# =============================================================================
# FILE: Makefile
# PURPOSE: Master command set for building, testing, and deploying the MCP Site Scanner
# -----------------------------------------------------------------------------
# 📖 DEVELOPER NOTES — READ LIKE SCRIPTURE
# 1. Each target is a covenant: clear, intentional, and observable.
# 2. Every run must speak aloud — no silent builds, no hidden logs.
# 3. Every report must live within ./reports/, the temple of truth.
# =============================================================================

# ─────────────────────────────────────────────────────────────────────────────
#  VARIABLE DECLARATIONS — Names reveal purpose
# ─────────────────────────────────────────────────────────────────────────────
APP             = mcp_site_scanner.py
RUNNER          = ./run-scan.sh
DOCKER_TEST_RUN = ./run-docker-tests.sh
VENV            = .venv
REPORT_DIR      = reports
TEST_REPORT_DIR = $(REPORT_DIR)/tests
IMAGE_NAME      = mcp-scanner
CONTAINER_NAME  = mcp-scanner
TARGET          = https://wwsad.b12sites.com/index

# ─────────────────────────────────────────────────────────────────────────────
#  ENVIRONMENT SETUP — Sanctify the virtual environment before all else
# ─────────────────────────────────────────────────────────────────────────────
$(VENV)/bin/activate:
	@echo "🔧 Preparing Python virtual environment..."
	@python3 -m venv $(VENV)
	@$(VENV)/bin/pip install -r requirements.txt
	@echo "📦 Environment ready. Dependencies installed."
	@echo "📂 Reports directory: $(REPORT_DIR)"

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: api — Launch the Flask API server for MCP
# ─────────────────────────────────────────────────────────────────────────────
api: $(VENV)/bin/activate
	@echo "🚀 Launching API server..."
	@bash $(RUNNER) api
	@echo "📂 Reports directory: $(REPORT_DIR)"

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: cli — Run an interactive CLI scan
# ─────────────────────────────────────────────────────────────────────────────
cli: $(VENV)/bin/activate
	@echo "🔍 Executing interactive CLI scan on $(TARGET)..."
	@bash $(RUNNER) cli $(TARGET)
	@echo "✅ CLI scan complete."
	@echo "📂 Reports directory: $(REPORT_DIR)"

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: once — Perform a single scan and exit (non-interactive)
# ─────────────────────────────────────────────────────────────────────────────
once: $(VENV)/bin/activate
	@echo "⚡ Running one-off scan for $(TARGET)..."
	@bash $(RUNNER) once $(TARGET)
	@echo "✅ One-off scan complete."
	@echo "📂 Reports directory: $(REPORT_DIR)"

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: test — Run cucumber + unit tests locally
# ─────────────────────────────────────────────────────────────────────────────
test: $(VENV)/bin/activate
	@echo "🧪 Running local test suite..."
	@bash $(RUNNER) test
	@echo "✅ Local tests executed."
	@echo "📂 Test reports located at: $(TEST_REPORT_DIR)"

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: docker-build — Build Docker image
# ───────────────────────────────────────
