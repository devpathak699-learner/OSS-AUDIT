#!/bin/bash
# Script 2: FOSS Package Inspector
# Author: Dev Pathak

# ── ANSI Colors ──────────────────────────────────────────────
BOLD="\033[1m"
GREEN="\033[1;32m"
RED="\033[1;31m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# ── Package Selection (CLI arg or default: git) ───────────────
PACKAGE="${1:-git}"

# ── Detect Package Manager ────────────────────────────────────
detect_pkg_manager() {
    if command -v apt &>/dev/null; then echo "apt"
    elif command -v dnf &>/dev/null; then echo "dnf"
    elif command -v rpm &>/dev/null; then echo "rpm"
    else echo "unknown"
    fi
}

PKG_MGR=$(detect_pkg_manager)

# ── Check if package is installed ────────────────────────────
is_installed() {
    case "$PKG_MGR" in
        apt) dpkg -l | grep -qw "$1" ;;
        dnf|rpm) rpm -q "$1" &>/dev/null ;;
        *) command -v "$1" &>/dev/null ;;
    esac
}

# ── Get package info ──────────────────────────────────────────
get_pkg_info() {
    case "$PKG_MGR" in
        apt) apt show "$1" 2>/dev/null | grep -E '^(Version|Maintainer|Homepage|Description)' ;;
        dnf) dnf info "$1" 2>/dev/null | grep -E '(Version|Summary|URL)' ;;
        rpm) rpm -qi "$1" 2>/dev/null | grep -E '(Version|Summary|URL)' ;;
        *) echo "  Package manager not supported for info lookup." ;;
    esac
}

# ── FOSS package descriptions ─────────────────────────────────
foss_note() {
    case "$1" in
        git)     echo "Git: decentralized version control, the backbone of open-source collaboration." ;;
        apache2|httpd) echo "Apache: battle-tested open web server powering ~30% of the internet." ;;
        mysql)   echo "MySQL: open source relational database used in millions of applications." ;;
        firefox) echo "Firefox: privacy-focused open web browser by Mozilla Foundation." ;;
        vim)     echo "Vim: powerful, extensible terminal text editor (GPL licensed)." ;;
        python3) echo "Python: interpreted, high-level, open-source general-purpose language." ;;
        *)       echo "${1^}: an open-source software package." ;;
    esac
}

# ── Header ───────────────────────────────────────────────────
echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════╗"
echo "║          FOSS Package Inspector              ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${RESET}"
echo -e "${BOLD}Package Manager:${RESET} $PKG_MGR"
echo -e "${BOLD}Target Package :${RESET} $PACKAGE"
echo -e "${CYAN}──────────────────────────────────────────────${RESET}"

# ── Installation Status ───────────────────────────────────────
if is_installed "$PACKAGE"; then
    echo -e "${GREEN}${BOLD}✔ $PACKAGE is INSTALLED${RESET}"
    echo ""
    echo -e "${BOLD}Package Details:${RESET}"
    get_pkg_info "$PACKAGE"
else
    echo -e "${RED}${BOLD}✘ $PACKAGE is NOT installed${RESET}"
    echo -e "${YELLOW}  Install with: ${PKG_MGR} install ${PACKAGE}${RESET}"
fi

echo -e "${CYAN}──────────────────────────────────────────────${RESET}"
echo -e "${BOLD}About this FOSS package:${RESET}"
echo "  $(foss_note "$PACKAGE")"

# ── Live Git Stats (only if package is git and git exists) ────
if [[ "$PACKAGE" == "git" ]] && command -v git &>/dev/null; then
    echo ""
    echo -e "${CYAN}──────────────────────────────────────────────${RESET}"
    echo -e "${BOLD}Git Runtime Info:${RESET}"
    printf "  ${BOLD}%-20s${RESET} %s\n" "Version"  "$(git --version)"
    printf "  ${BOLD}%-20s${RESET} %s\n" "Config user"  "$(git config --global user.name 2>/dev/null || echo 'Not set')"
    printf "  ${BOLD}%-20s${RESET} %s\n" "Config email" "$(git config --global user.email 2>/dev/null || echo 'Not set')"
    printf "  ${BOLD}%-20s${RESET} %s\n" "Default branch" "$(git config --global init.defaultBranch 2>/dev/null || echo 'master')"

    # Show recent commits if inside a git repo
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        echo ""
        echo -e "${BOLD}  Last 5 commits in current repo:${RESET}"
        git log --oneline -5 2>/dev/null | sed 's/^/    /'
    fi
fi

echo ""
echo -e "${GREEN}✔ Package inspection complete.${RESET}"
