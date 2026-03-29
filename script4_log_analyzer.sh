#!/bin/bash
# Script 4: Log File Analyzer
# Author: Dev Pathak

# ── ANSI Colors ──────────────────────────────────────────────
BOLD="\033[1m"
GREEN="\033[1;32m"
RED="\033[1;31m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# ── Usage ─────────────────────────────────────────────────────
usage() {
    echo -e "${BOLD}Usage:${RESET} $0 <logfile> [keyword]"
    echo ""
    echo "  <logfile>   Path to the log file to analyze"
    echo "  [keyword]   Optional keyword to search (default: error)"
    echo ""
    echo -e "${BOLD}Examples:${RESET}"
    echo "  $0 /var/log/syslog"
    echo "  $0 /var/log/syslog warning"
    exit 1
}

# ── Argument Validation ───────────────────────────────────────
if [ -z "$1" ]; then
    usage
fi

LOGFILE="$1"
KEYWORD="${2:-error}"

if [ ! -f "$LOGFILE" ]; then
    echo -e "${RED}${BOLD}✘ Error:${RESET} File not found — '$LOGFILE'"
    echo "  Please provide a valid log file path."
    exit 1
fi

if [ ! -r "$LOGFILE" ]; then
    echo -e "${RED}${BOLD}✘ Error:${RESET} Permission denied reading '$LOGFILE'"
    echo "  Try: sudo $0 $LOGFILE $KEYWORD"
    exit 1
fi

# ── Header ───────────────────────────────────────────────────
echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════╗"
echo "║           Log File Analyzer                  ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${RESET}"
printf "${BOLD}%-16s${RESET} %s\n" "Log File"  "$LOGFILE"
printf "${BOLD}%-16s${RESET} %s\n" "File Size" "$(du -sh "$LOGFILE" | cut -f1)"
printf "${BOLD}%-16s${RESET} %s\n" "Total Lines" "$(wc -l < "$LOGFILE")"
printf "${BOLD}%-16s${RESET} %s\n" "Search Term"  "$KEYWORD"

echo -e "${CYAN}──────────────────────────────────────────────${RESET}"

# ── Count using while-read loop (as required by assignment rubric) ─
COUNT=0
while IFS= read -r LINE; do
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))
    fi
done < "$LOGFILE"

if [ "$COUNT" -gt 0 ]; then
    echo -e "${BOLD}Primary Keyword:${RESET} ${YELLOW}'$KEYWORD'${RESET} found ${BOLD}${YELLOW}$COUNT${RESET} time(s)"
else
    echo -e "${BOLD}Primary Keyword:${RESET} ${GREEN}'$KEYWORD'${RESET} — ${GREEN}not found${RESET} (log looks clean)"
fi

# ── Severity Breakdown ────────────────────────────────────────
echo ""
echo -e "${BOLD}Severity Breakdown:${RESET}"
for LEVEL in error warning critical info debug; do
    LEVEL_COUNT=$(grep -ci "$LEVEL" "$LOGFILE")
    if [ "$LEVEL_COUNT" -gt 0 ]; then
        case "$LEVEL" in
            error|critical) COLOR="${RED}" ;;
            warning)        COLOR="${YELLOW}" ;;
            *)              COLOR="${GREEN}" ;;
        esac
        printf "  ${COLOR}${BOLD}%-10s${RESET} %s occurrences\n" \
            "[$LEVEL]" "$LEVEL_COUNT"
    fi
done

# ── Timestamps of First & Last Match ─────────────────────────
echo ""
echo -e "${CYAN}──────────────────────────────────────────────${RESET}"
echo -e "${BOLD}First 5 matches for '${KEYWORD}':${RESET}"
grep -i "$KEYWORD" "$LOGFILE" 2>/dev/null | head -5 | \
    awk '{print "  "NR". "$0}' | cut -c1-100

echo ""
echo -e "${BOLD}Last 5 matches for '${KEYWORD}':${RESET}"
grep -i "$KEYWORD" "$LOGFILE" 2>/dev/null | tail -5 | \
    awk '{print "  "NR". "$0}' | cut -c1-100

echo ""
echo -e "${GREEN}✔ Log analysis complete.${RESET}"
