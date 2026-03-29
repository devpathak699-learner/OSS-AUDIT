#!/bin/bash
# Script 5: Open Source Manifesto Generator
# Author: Dev Pathak

# ── ANSI Colors ──────────────────────────────────────────────
BOLD="\033[1m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# Note on Aliases: To run this script easily from anywhere, you could add
# an alias to your ~/.bashrc file, for example: alias manifesto='./script5_manifesto.sh'

# ── Header ───────────────────────────────────────────────────
echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════╗"
echo "║      Open Source Manifesto Generator         ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${RESET}"

echo "Answer three questions to generate your personal open-source manifesto."
echo ""

# ── Input with Validation (re-prompt on empty) ────────────────
prompt_required() {
    local PROMPT="$1"
    local VAR=""
    while [ -z "$VAR" ]; do
        read -p "$(echo -e "${BOLD}${PROMPT}${RESET} ")" VAR
        if [ -z "$VAR" ]; then
            echo -e "${YELLOW}  ⚠ This field cannot be empty. Please answer.${RESET}"
        fi
    done
    echo "$VAR"
}

TOOL=$(prompt_required    "🔧  Open-source tool you use:")
FREEDOM=$(prompt_required "🕊️  What does freedom mean to you:")
BUILD=$(prompt_required   "🚀  What will you build & share:")

# ── Output File ───────────────────────────────────────────────
DATE=$(date '+%d %B %Y')
OUTPUT="manifesto_$(whoami).txt"

# ── Overwrite Guard ───────────────────────────────────────────
if [ -f "$OUTPUT" ]; then
    echo ""
    echo -e "${YELLOW}⚠  A manifesto already exists: ${BOLD}$OUTPUT${RESET}"
    read -p "$(echo -e "${BOLD}Overwrite it? [y/N]: ${RESET}")" CONFIRM
    CONFIRM="${CONFIRM,,}"   # lowercase
    if [[ "$CONFIRM" != "y" && "$CONFIRM" != "yes" ]]; then
        echo -e "${CYAN}  Manifesto not overwritten. Exiting.${RESET}"
        exit 0
    fi
fi

# ── Write Manifesto ───────────────────────────────────────────
{
    echo "════════════════════════════════════════════"
    echo "           MY OPEN SOURCE MANIFESTO"
    echo "════════════════════════════════════════════"
    echo ""
    echo "Author   : $(whoami)"
    echo "Date     : $DATE"
    echo ""
    echo "On $DATE, I believe that open source is about $FREEDOM."
    echo ""
    echo "Tools like $TOOL empower developers worldwide, enabling"
    echo "collaboration, transparency, and shared progress."
    echo ""
    echo "I aim to build $BUILD and share it freely with the world."
    echo ""
    echo "Because open source is not just code —"
    echo "it is a philosophy of trust, community, and freedom."
    echo ""
    echo "════════════════════════════════════════════"
    echo "         Signed with conviction, $(whoami)"
    echo "════════════════════════════════════════════"
} > "$OUTPUT"

# ── Display Result ────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}✔ Manifesto saved to: ${OUTPUT}${RESET}"
echo ""
echo -e "${CYAN}──────────────────────────────────────────────${RESET}"
cat "$OUTPUT"
echo -e "${CYAN}──────────────────────────────────────────────${RESET}"
echo ""
echo -e "${GREEN}✔ Manifesto generation complete.${RESET}"
