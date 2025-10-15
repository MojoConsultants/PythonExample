# =============================================================================
# FILE: Makefile
# PURPOSE: Provide unified developer shortcuts for running, testing, and packaging the MCP Site Scanner.
# -----------------------------------------------------------------------------
# 📖 DEVELOPER NOTES — READ LIKE SCRIPTURE
# 1. Each target declares its mission clearly.
# 2. `make` is the commandment of convenience — no long scripts, just clarity.
# 3. Outputs and reports are sacred; they must always persist under ./reports/.
# =============================================================================

# ─────────────────────────────────────────────────────────────────────────────
#  VARIABLE DECLARATIONS — Each name reveals its duty
# ─────────────────────────────────────────────────────────────────────────────
APP = mcp_site_scanner.py           # The core scanner engine
RUNNER = ./run-scan.sh              # The unified script for all modes
VENV = .venv                        # Python virtual environment
REPORT_DIR = reports                # Where all reports dwell
IMAGE_NAME = mcp-scanner            # Docker image name
CONTAINER_NAME = mcp-scanner        # Docker container name
TARGET = https://wwsad.b12sites.com/index  # Default scan target

# ─────────────────────────────────────────────────────────────────────────────
#  ENVIRONMENT — Ensure virtual environment exists before running anything
# ─────────────────────────────────────────────────────────────────────────────
$(VENV)/bin/activate:
	@echo "🔧 Creating virtual environment..."
	@python3 -m venv $(VENV)
	@$(VENV)/bin/pip install -r requirements.txt

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: api — Start the Flask API server for MCP integration
# ─────────────────────────────────────────────────────────────────────────────
api: $(VENV)/bin/activate
	@echo "🚀 Launching API mode..."
	@bash $(RUNNER) api

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: cli — Run interactive CLI scan (prints progress live)
# ─────────────────────────────────────────────────────────────────────────────
cli: $(VENV)/bin/activate
	@echo "🔍 Running CLI scan on $(TARGET)"
	@bash $(RUNNER) cli $(TARGET)

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: once — Run a single scan and exit (non-interactive)
# ─────────────────────────────────────────────────────────────────────────────
once: $(VENV)/bin/activate
	@echo "⚡ Executing one-off scan on $(TARGET)"
	@bash $(RUNNER) once $(TARGET)

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: test — Execute cucumber and unit tests
# ─────────────────────────────────────────────────────────────────────────────
test: $(VENV)/bin/activate
	@echo "🧪 Running full test suite..."
	@bash $(RUNNER) test

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: docker-build — Build the scanner Docker image
# ─────────────────────────────────────────────────────────────────────────────
docker-build:
	@echo "🐳 Building Docker image: $(IMAGE_NAME)"
	@docker build -t $(IMAGE_NAME) .

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: docker-run — Run containerized scanner with persistent reports
# ─────────────────────────────────────────────────────────────────────────────
docker-run:
	@echo "🚀 Running container $(CONTAINER_NAME) with volume-mounted reports..."
	@docker run --rm -it \
		-p 8020:8020 \
		-v $(PWD)/$(REPORT_DIR):/app/reports \
		--name $(CONTAINER_NAME) \
		$(IMAGE_NAME)

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: clean — Purge build artifacts, logs, and temporary files
# ─────────────────────────────────────────────────────────────────────────────
clean:
	@echo "🧹 Purging logs, cache, and temp files..."
	@rm -rf $(VENV) $(REPORT_DIR) logs __pycache__

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: help — Summarize all make targets
# ─────────────────────────────────────────────────────────────────────────────
help:
	@echo ""
	@echo "🧭 MAKE COMMANDS (MCP Site Scanner)"
	@echo "-----------------------------------"
	@echo " make api          → Launch API server (Flask)"
	@echo " make cli          → Run interactive CLI scan"
	@echo " make once         → Run one-off scan (auto-report)"
	@echo " make test         → Run cucumber + unit tests"
	@echo " make docker-build → Build Docker image"
	@echo " make docker-run   → Run container with reports volume"
	@echo " make clean        → Purge venv, logs, and temp files"
	@echo ""
# =============================================================================
#  END OF MAKEFILE
# =============================================================================
