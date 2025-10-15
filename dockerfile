# =============================================================================
# FILE: Dockerfile
# PURPOSE: Build a portable container for the MCP Site Scanner.
# -----------------------------------------------------------------------------
# 📖 DEVELOPER NOTES — READ LIKE SCRIPTURE
# 1. Each layer declares its intent plainly.
# 2. Minimalism is virtue: fewer layers, faster builds.
# 3. Every COPY, RUN, and CMD step should serve the mission — scanning and reporting.
# =============================================================================

# ─────────────────────────────────────────────────────────────────────────────
#  BASE IMAGE — Use stable Python runtime
# ─────────────────────────────────────────────────────────────────────────────
FROM python:3.13-slim

# ─────────────────────────────────────────────────────────────────────────────
#  WORK DIRECTORY — The holy workspace of the scanner
# ─────────────────────────────────────────────────────────────────────────────
WORKDIR /app

# ─────────────────────────────────────────────────────────────────────────────
#  COPY DEPENDENCIES FIRST — To leverage Docker cache wisely
# ─────────────────────────────────────────────────────────────────────────────
COPY requirements.txt .

# ─────────────────────────────────────────────────────────────────────────────
#  INSTALL DEPENDENCIES — Quietly, faithfully, without cache
# ─────────────────────────────────────────────────────────────────────────────
RUN pip install --no-cache-dir -r requirements.txt

# ─────────────────────────────────────────────────────────────────────────────
#  COPY SOURCE CODE — Bring in the scanner and scripts
# ─────────────────────────────────────────────────────────────────────────────
COPY . .

# ─────────────────────────────────────────────────────────────────────────────
#  EXPOSE PORT — The port where the Flask API preaches its truth
# ─────────────────────────────────────────────────────────────────────────────
EXPOSE 8020

# ─────────────────────────────────────────────────────────────────────────────
#  ENTRYPOINT — The script that unites all modes: CLI, API, One-Off
# ─────────────────────────────────────────────────────────────────────────────
ENTRYPOINT ["bash", "run-scan.sh", "api"]

# =============================================================================
#  END OF DOCKERFILE
# =============================================================================
