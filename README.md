# Python Example: 
🛡️ MCP Site Scanner

A minimal **security and reliability scanner** for websites that:
- Verifies link health  
- Detects broken URLs  
- Identifies “Add Member” or “Signup” forms  
- Attempts safe test submissions  
- Generates a professional HTML report  

---

## ⚙️ Project Overview

**Purpose:**  
Provide an automated, MCP-compatible tool to test site reliability and report web health.  
It’s designed for DevOps pipelines, pentesters, and QA engineers needing quick site diagnostics.

---

## 🧭 Modes of Operation

| Mode | Description | Command Example |
|------|--------------|----------------|
| **API Mode** | Launch Flask API server (MCP endpoint) | `./run-scan.sh api` |
| **CLI Mode** | Run scan interactively | `./run-scan.sh cli https://example.com` |
| **One-Off Mode** | Run scan once and exit with report | `./run-scan.sh once https://example.com` |
| **Test Mode** | Run cucumber + unit tests | `./run-scan.sh test` |

---

## 🧩 Project Structure

Running The Scanner  API 
./run-scan.sh api

CLI Scan 
./run-scan.sh cli https://wwsad.b12sites.com/index

One -off Scan 
./run-scan.sh once https://wwsad.b12sites.com/index

Run Tests 
./run-scan.sh test

##DOCKER DEPLOYMENT

docker build -t mcp-scanner .
docker run -p 8020:8020 mcp-scanner
Testing Strategy

Cucumber (behave) for behavior-driven acceptance tests

Pytest for unit and functional verification

# =============================================================================
# FILE: <filename>
# PURPOSE: <what this file is for>
# -----------------------------------------------------------------------------
# 📖 DEVELOPER NOTES — READ LIKE SCRIPTURE
# 1. Each section states its reason for being.
# 2. Variables declare purpose clearly.
# 3. The flow must be obvious to future maintainers.
# =============================================================================
