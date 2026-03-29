#!/bin/bash
# Script 3: Disk and Permission Auditor
# Author: Dev Pathak

# ── ANSI Colors ──────────────────────────────────────────────
BOLD="\033[1m"
GREEN="\033[1;32m"
RED="\033[1;31m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp")

# ── Header ───────────────────────────────────────────────────
echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════╗"
echo "║        Disk & Permission Auditor             ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${RESET}"

# ── Directory Audit Table ─────────────────────────────────────
printf "${BOLD}%-15s %-25s %-8s %-10s %-10s${RESET}\n" \
    "Directory" "Permissions / Owner" "Group" "Size" "Status"
echo -e "${CYAN}──────────────────────────────────────────────────────────────────${RESET}"

for DIR in "${DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        PERMS=$(ls -ld "$DIR" | awk '{print $1}')
        OWNER=$(ls -ld "$DIR" | awk '{print $3}')
        GROUP=$(ls -ld "$DIR" | awk '{print $4}')
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)
        printf "%-15s ${GREEN}%-14s${RESET} %-10s %-10s %-10s ${GREEN}OK${RESET}\n" \
            "$DIR" "$PERMS $OWNER" "$GROUP" "$SIZE"
    else
        printf "%-15s ${RED}%-34s${RESET} ${RED}MISSING${RESET}\n" "$DIR" "Directory does not exist"
    fi
done

echo -e "${CYAN}──────────────────────────────────────────────────────────────────${RESET}"

# ── World-Writable Directory Warning ─────────────────────────
echo ""
echo -e "${BOLD}World-Writable Directory Check:${RESET}"
WW_DIRS=$(find /tmp /var/tmp -maxdepth 1 -perm -0002 -type d 2>/dev/null)
if [ -n "$WW_DIRS" ]; then
    echo -e "${YELLOW}  ⚠ World-writable directories found:${RESET}"
    echo "$WW_DIRS" | sed 's/^/    /'
else
    echo -e "${GREEN}  ✔ No unexpected world-writable directories found.${RESET}"
fi

# ── Git Config Check ─────────────────────────────────────────
echo ""
echo -e "${BOLD}Git Configuration Check:${RESET}"
CONFIG_DIR="$HOME/.gitconfig"

if [ -f "$CONFIG_DIR" ]; then
    echo -e "${GREEN}  ✔ Git config found: $CONFIG_DIR${RESET}"
    printf "    ${BOLD}%-20s${RESET} %s\n" "Permissions:" "$(ls -l "$CONFIG_DIR" | awk '{print $1, $3, $4}')"
    printf "    ${BOLD}%-20s${RESET} %s\n" "Last modified:" "$(stat -c '%y' "$CONFIG_DIR" 2>/dev/null | cut -d'.' -f1)"
else
    echo -e "${YELLOW}  ⚠ Git config not found at $CONFIG_DIR${RESET}"
fi

# ── Git Repository Scan ───────────────────────────────────────
echo ""
echo -e "${BOLD}Git Repository Scan (home directory):${RESET}"
GIT_REPOS=$(find "$HOME" -maxdepth 4 -name ".git" -type d 2>/dev/null | sed 's|/.git$||')
REPO_COUNT=$(echo "$GIT_REPOS" | grep -c '.' 2>/dev/null || echo 0)

if [ "$REPO_COUNT" -gt 0 ]; then
    echo -e "${GREEN}  ✔ Found $REPO_COUNT git repo(s):${RESET}"
    echo "$GIT_REPOS" | head -10 | sed 's/^/    /'
    [ "$REPO_COUNT" -gt 10 ] && echo "    ... and $((REPO_COUNT - 10)) more."
else
    echo -e "${YELLOW}  No git repositories found in $HOME${RESET}"
fi

echo ""
echo -e "${GREEN}✔ Disk audit complete.${RESET}"
