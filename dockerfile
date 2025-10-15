# =============================================================================
# FILE: Dockerfile
# PURPOSE: Build a self-contained container for the MCP Site Scanner
# -----------------------------------------------------------------------------
# 📖 DEVELOPER NOTES — READ LIKE SCRIPTURE
# 1. Containers should preach simplicity — minimal layers, clear ports.
# 2. Reports must survive container restarts, hence a mounted volume.
# 3. The ENTRYPOINT binds this vessel to its Bash gospel: run-scan.sh.
# =============================================================================

# ─────────────────────────────────────────────────────────────────────────────
#  BASE IMAGE — Use stable, secure Python runtime
# ─────────────────────────────────────────────────────────────────────────────
FROM python:3.13-slim

# ─────────────────────────────────────────────────────────────────────────────
#  WORK DIRECTORY — The scanner’s sanctuary
# ─────────────────────────────────────────────────────────────────────────────
WORKDIR /app

# ─────────────────────────────────────────────────────────────────────────────
#  COPY REQUIREMENTS — Install dependencies separately for Docker caching
# ─────────────────────────────────────────────────────────────────────────────
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# ─────────────────────────────────────────────────────────────────────────────
#  COPY SOURCE CODE — Bring scanner, tests, and helpers
# ─────────────────────────────────────────────────────────────────────────────
COPY . .

# ─────────────────────────────────────────────────────────────────────────────
#  EXPOSE PORT — Where the Flask API speaks truth
# ─────────────────────────────────────────────────────────────────────────────
EXPOSE 8020

# ─────────────────────────────────────────────────────────────────────────────
#  VOLUME — Mount point for persistent reports (host <-> container)
# ─────────────────────────────────────────────────────────────────────────────
VOLUME ["/app/reports"]

# ─────────────────────────────────────────────────────────────────────────────
#  ENTRYPOINT — Launch the gospel runner (default: API mode)
# ─────────────────────────────────────────────────────────────────────────────
ENTRYPOINT ["bash", "run-scan.sh", "api"]

# =============================================================================
#  END OF DOCKERFILE
# =============================================================================
