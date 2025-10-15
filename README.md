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

