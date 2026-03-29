#!/bin/bash
# Master Runner — OSS Audit Project
# Author: Dev Pathak

set -euo pipefail   # exit on error, unbound var, pipe failure

# ── ANSI Colors ──────────────────────────────────────────────
BOLD="\033[1m"
GREEN="\033[1;32m"
RED="\033[1;31m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# ── Setup ─────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_DIR="$SCRIPT_DIR/reports"
LOG_FILE="$REPORT_DIR/audit_$(date '+%Y-%m-%d_%H-%M-%S').log"
TOTAL_START=$(date +%s)
FAILED_SCRIPTS=()

mkdir -p "$REPORT_DIR"

# ── Trap on unexpected exit ───────────────────────────────────
trap 'echo -e "\n${RED}${BOLD}✘ Aborted at line $LINENO. Check $LOG_FILE${RESET}"' ERR

# ── Logging helper: tee to terminal AND log file ──────────────
log() { echo -e "$@" | tee -a "$LOG_FILE"; }

# ── Script runner with timing and error capture ───────────────
run_script() {
    local NAME="$1"
    local CMD="$2"
    local START END ELAPSED

    log ""
    log "${CYAN}${BOLD}▶ Running $NAME ...${RESET}"
    log "${CYAN}──────────────────────────────────────────────${RESET}"

    START=$(date +%s)

    # Run script; capture failure without stopping due to set -e
    if bash "$CMD" 2>&1 | tee -a "$LOG_FILE"; then
        END=$(date +%s)
        ELAPSED=$((END - START))
        log "${GREEN}${BOLD}✔ $NAME completed in ${ELAPSED}s${RESET}"
    else
        END=$(date +%s)
        ELAPSED=$((END - START))
        log "${RED}${BOLD}✘ $NAME FAILED after ${ELAPSED}s${RESET}"
        FAILED_SCRIPTS+=("$NAME")
    fi
}

# ── Header ───────────────────────────────────────────────────
log "${CYAN}${BOLD}"
log "╔══════════════════════════════════════════════╗"
log "║       Open Source Audit Project — Git        ║"
log "║            Master Execution Runner           ║"
log "╚══════════════════════════════════════════════╝"
log "${RESET}"
log "${BOLD}Audit started:${RESET} $(date '+%A, %d %B %Y — %H:%M:%S')"
log "${BOLD}Report file  :${RESET} $LOG_FILE"

# ── Check/Install Git ─────────────────────────────────────────
log ""
log "${BOLD}Checking Git installation...${RESET}"
if ! command -v git &>/dev/null; then
    log "${YELLOW}  Git not found. Installing...${RESET}"
    if command -v apt &>/dev/null; then
        sudo apt update && sudo apt install git -y | tee -a "$LOG_FILE"
    elif command -v dnf &>/dev/null; then
        sudo dnf install git -y | tee -a "$LOG_FILE"
    else
        log "${RED}  Cannot auto-install git — no known package manager found.${RESET}"
        exit 1
    fi
else
    log "${GREEN}  ✔ Git is installed: $(git --version)${RESET}"
fi

# ── Grant Execute Permissions ─────────────────────────────────
chmod +x "$SCRIPT_DIR"/script*.sh

# ── Run All Scripts ───────────────────────────────────────────
run_script "Script 1 — System Identity"      "$SCRIPT_DIR/script1_system_identity.sh"
run_script "Script 2 — FOSS Package Inspector" "$SCRIPT_DIR/script2_package_inspector.sh"
run_script "Script 3 — Disk & Permission Auditor" "$SCRIPT_DIR/script3_disk_auditor.sh"
run_script "Script 4 — Log Analyzer (syslog)" \
    <(echo '#!/bin/bash'; echo "bash \"$SCRIPT_DIR/script4_log_analyzer.sh\" /var/log/syslog error")
run_script "Script 5 — Manifesto Generator"  "$SCRIPT_DIR/script5_manifesto.sh"

# ── Summary ───────────────────────────────────────────────────
TOTAL_END=$(date +%s)
TOTAL_ELAPSED=$((TOTAL_END - TOTAL_START))

log ""
log "${CYAN}${BOLD}══════════════════════════════════════════════${RESET}"
log "${BOLD}Audit Summary${RESET}"
log "${CYAN}──────────────────────────────────────────────${RESET}"
log "${BOLD}Total time    :${RESET} ${TOTAL_ELAPSED}s"
log "${BOLD}Report saved  :${RESET} $LOG_FILE"

if [ ${#FAILED_SCRIPTS[@]} -eq 0 ]; then
    log "${GREEN}${BOLD}✔ All scripts executed successfully!${RESET}"
else
    log "${RED}${BOLD}✘ ${#FAILED_SCRIPTS[@]} script(s) failed:${RESET}"
    for F in "${FAILED_SCRIPTS[@]}"; do
        log "${RED}  - $F${RESET}"
    done
    exit 1
fi

log "${CYAN}${BOLD}══════════════════════════════════════════════${RESET}"
