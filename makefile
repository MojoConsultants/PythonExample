# =============================================================================
# FILE: Makefile
# PURPOSE: Master control for building, scanning, testing, and deploying the MCP Site Scanner.
# -----------------------------------------------------------------------------
# 📖 DEVELOPER NOTES — READ LIKE SCRIPTURE
# 1. Tabs are sacred; spaces will break the covenant.
# 2. Each target speaks loudly and prints progress in real-time.
# 3. All reports reside in ./reports — the temple of truth.
# =============================================================================

# ─────────────────────────────────────────────────────────────────────────────
#  VARIABLE DECLARATIONS
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
#  ENVIRONMENT SETUP
# ─────────────────────────────────────────────────────────────────────────────
$(VENV)/bin/activate:
	@echo "🔧 Creating Python virtual environment..."
	@python3 -m venv $(VENV)
	@$(VENV)/bin/pip install -r requirements.txt
	@echo "📦 Environment ready."
	@echo "📂 Reports directory: $(REPORT_DIR)"

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: api
# ─────────────────────────────────────────────────────────────────────────────
api: $(VENV)/bin/activate
	@echo "🚀 Launching API server..."
	@bash $(RUNNER) api
	@echo "📂 Reports directory: $(REPORT_DIR)"

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: cli
# ─────────────────────────────────────────────────────────────────────────────
cli: $(VENV)/bin/activate
	@echo "🔍 Running interactive CLI scan on $(TARGET)..."
	@bash $(RUNNER) cli $(TARGET)
	@echo "✅ CLI scan complete."
	@echo "📂 Reports directory: $(REPORT_DIR)"

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: once
# ─────────────────────────────────────────────────────────────────────────────
once: $(VENV)/bin/activate
	@echo "⚡ Running one-off scan for $(TARGET)..."
	@bash $(RUNNER) once $(TARGET)
	@echo "✅ One-off scan complete."
	@echo "📂 Reports directory: $(REPORT_DIR)"

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: test
# ─────────────────────────────────────────────────────────────────────────────
test: $(VENV)/bin/activate
	@echo "🧪 Running local tests (cucumber + unit)..."
	@bash $(RUNNER) test
	@echo "✅ Local tests executed."
	@echo "📂 Reports directory: $(TEST_REPORT_DIR)"

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: docker-build
# ─────────────────────────────────────────────────────────────────────────────
docker-build:
	@echo "🐳 Building Docker image: $(IMAGE_NAME)..."
	@docker build -t $(IMAGE_NAME) .
	@echo "✅ Docker image built."
	@echo "📂 Reports directory: $(REPORT_DIR)"

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: docker-run
# ─────────────────────────────────────────────────────────────────────────────
docker-run:
	@echo "🚀 Running Docker container: $(CONTAINER_NAME)..."
	@docker run --rm -it \
		-p 8020:8020 \
		-v $(PWD)/$(REPORT_DIR):/app/reports \
		--name $(CONTAINER_NAME) \
		$(IMAGE_NAME)
	@echo "✅ Container exited."
	@echo "📂 Reports directory: $(REPORT_DIR)"

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: docker-tests
# ─────────────────────────────────────────────────────────────────────────────
docker-tests:
	@echo "🧩 Running full Dockerized test suite..."
	@bash $(DOCKER_TEST_RUN)
	@echo "✅ Dockerized tests complete."
	@echo "📂 Test reports directory: $(TEST_REPORT_DIR)"

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: docker-compose-up
# ─────────────────────────────────────────────────────────────────────────────
docker-compose-up:
	@echo "🌐 Starting stack via docker-compose..."
	@docker compose up --build
	@echo "📂 Reports directory: $(REPORT_DIR)"

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: docker-compose-down
# ─────────────────────────────────────────────────────────────────────────────
docker-compose-down:
	@echo "🧹 Stopping docker-compose stack..."
	@docker compose down
	@echo "✅ Stack stopped. Reports preserved at: $(REPORT_DIR)"

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: clean
# ─────────────────────────────────────────────────────────────────────────────
clean:
	@echo "🧽 Cleaning environment..."
	@rm -rf $(VENV) $(REPORT_DIR) logs __pycache__
	@echo "✅ Environment cleaned."

# ─────────────────────────────────────────────────────────────────────────────
#  TARGET: help
# ─────────────────────────────────────────────────────────────────────────────
help:
	@echo ""
	@echo "🧭 MCP SITE SCANNER — Command Guide"
	@echo "----------------------------------"
	@echo " make api                → Launch API server"
	@echo " make cli                → Run interactive CLI scan"
	@echo " make once               → Run one-off scan"
	@echo " make test               → Run local cucumber + unit tests"
	@echo " make docker-build       → Build Docker image"
	@echo " make docker-run         → Run containerized API"
	@echo " make docker-tests       → Run tests inside Docker (HTML reports)"
	@echo " make docker-compose-up  → Start stack via docker-compose"
	@echo " make docker-compose-down→ Stop docker-compose stack"
	@echo " make clean              → Purge environment"
	@echo ""
	@echo "📂 Reports directory: $(REPORT_DIR)"
	@echo ""

# =============================================================================
#  END OF MAKEFILE
# =============================================================================
