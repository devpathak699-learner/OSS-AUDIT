#!/bin/bash
# Script 1: System Identity Report
# Author: Dev Pathak

# ── ANSI Colors ──────────────────────────────────────────────
BOLD="\033[1m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

STUDENT_NAME="Dev Pathak"
SOFTWARE_CHOICE="Git"

# ── Gather System Info ────────────────────────────────────────
KERNEL=$(uname -r)
ARCH=$(uname -m)
USER_NAME=$(whoami)
UPTIME=$(uptime -p 2>/dev/null || uptime)
DATE=$(date '+%A, %d %B %Y — %H:%M:%S')
DISTRO=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d '"' -f2 || echo "Unknown")
CPU=$(grep -m1 "model name" /proc/cpuinfo 2>/dev/null | cut -d ':' -f2 | xargs || echo "N/A")
RAM_KB=$(grep MemTotal /proc/meminfo 2>/dev/null | awk '{print $2}')
RAM_GB=$(awk "BEGIN {printf \"%.1f GB\", $RAM_KB/1048576}" 2>/dev/null || echo "N/A")
GIT_VER=$(git --version 2>/dev/null || echo "Git not installed")
GIT_USER=$(git config --global user.name 2>/dev/null || echo "Not configured")

# ── Output ────────────────────────────────────────────────────
echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════╗"
echo "║        Open Source Audit — System Report     ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${RESET}"

printf "${BOLD}%-16s${RESET} %s\n" "Student"     "$STUDENT_NAME"
printf "${BOLD}%-16s${RESET} %s\n" "Software"    "$SOFTWARE_CHOICE"
echo -e "${CYAN}──────────────────────────────────────────────${RESET}"
printf "${BOLD}%-16s${RESET} %s\n" "Date"        "$DATE"
printf "${BOLD}%-16s${RESET} %s\n" "User"        "$USER_NAME"
printf "${BOLD}%-16s${RESET} %s\n" "Home Dir"    "$HOME_DIR"
printf "${BOLD}%-16s${RESET} %s\n" "Distro"      "$DISTRO"
printf "${BOLD}%-16s${RESET} %s\n" "Kernel"      "$KERNEL"
printf "${BOLD}%-16s${RESET} %s\n" "Architecture" "$ARCH"
printf "${BOLD}%-16s${RESET} %s\n" "CPU"         "$CPU"
printf "${BOLD}%-16s${RESET} %s\n" "RAM"         "$RAM_GB"
printf "${BOLD}%-16s${RESET} %s\n" "Uptime"      "$UPTIME"
echo -e "${CYAN}──────────────────────────────────────────────${RESET}"
printf "${BOLD}%-16s${RESET} %s\n" "Git Version" "$GIT_VER"
printf "${BOLD}%-16s${RESET} %s\n" "Git User"    "$GIT_USER"
printf "${BOLD}%-16s${RESET} %s\n" "Kernel Lic." "GPL v2"

echo ""
echo -e "${GREEN}✔ System identity report complete.${RESET}"
