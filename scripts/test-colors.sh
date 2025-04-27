#!/usr/bin/env bash

########################################################################################
# File: test-colors.sh
# Description: Test script to display all available colors
########################################################################################

# Source the UI library to get colors
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/lib/_ui.sh"

echo -e "\n${BRIGHT_WHITE}Available Colors:${WHITE}"
echo -e "${RED}This is RED text${WHITE}"
echo -e "${GREEN}This is GREEN text${WHITE}"
echo -e "${DARK_GREEN}This is DARK_GREEN text${WHITE}"
echo -e "${YELLOW}This is YELLOW text${WHITE}"
echo -e "${ORANGE}This is ORANGE text${WHITE}" 
echo -e "${DARK_ORANGE}This is DARK_ORANGE text${WHITE}"
echo -e "${BLUE}This is BLUE text${WHITE}"
echo -e "${GRAY}This is GRAY text${WHITE}"
echo -e "${BRIGHT_WHITE}This is BRIGHT_WHITE text${WHITE}"
echo -e "${WHITE}This is WHITE text${WHITE}"
echo -e "${OFF_WHITE}This is OFF_WHITE text${WHITE}"

echo -e "\n${BRIGHT_WHITE}Format Options:${WHITE}"
echo -e "${BOLD}This is BOLD text${REGULAR}${WHITE}"
echo -e "This is ${BOLD}partially bold${REGULAR} text${WHITE}"

echo -e "\n${BRIGHT_WHITE}Color Combinations:${WHITE}"
echo -e "${RED}${BOLD}This is BOLD RED text${REGULAR}${WHITE}"
echo -e "${GREEN}${BOLD}This is BOLD GREEN text${REGULAR}${WHITE}"
echo -e "${DARK_GREEN}${BOLD}This is BOLD DARK_GREEN text${REGULAR}${WHITE}"
echo -e "${YELLOW}${BOLD}This is BOLD YELLOW text${REGULAR}${WHITE}"
echo -e "${ORANGE}${BOLD}This is BOLD ORANGE text${REGULAR}${WHITE}"
echo -e "${DARK_ORANGE}${BOLD}This is BOLD DARK_ORANGE text${REGULAR}${WHITE}"
echo -e "${BLUE}${BOLD}This is BOLD BLUE text${REGULAR}${WHITE}"

echo -e "\n${BRIGHT_WHITE}Side by Side Comparison:${WHITE}"
echo -e "${YELLOW}YELLOW${WHITE} vs ${ORANGE}ORANGE${WHITE} vs ${DARK_ORANGE}DARK_ORANGE${WHITE} (should be visibly different)"

echo -e "\n${BRIGHT_WHITE}Color Gradients:${WHITE}"
echo -e "${YELLOW}■${ORANGE}■${DARK_ORANGE}■${RED}■${WHITE} (Yellow → Orange → Dark Orange → Red)"
echo -e "${GREEN}■${DARK_GREEN}■${BLUE}■${WHITE} (Green → Dark Green → Blue)"

echo -e "\n${BRIGHT_WHITE}Symbols:${WHITE}"
echo -e "${GREEN}${SUCCESS_SYMBOL}${WHITE} Success symbol"
echo -e "${RED}${FAILURE_SYMBOL}${WHITE} Failure symbol"
echo -e "${YELLOW}${WARNING_SYMBOL}${WHITE} Warning symbol"
echo -e "${BLUE}${INFO_SYMBOL}${WHITE} Info symbol"
echo -e "${BLUE}${SKIPPED_SYMBOL}${WHITE} Skipped symbol"
echo -e "${BLUE}${ARROW_RIGHT}${WHITE} Arrow right symbol"
echo -e "${BLUE}${ARROW_LEFT}${WHITE} Arrow left symbol"
echo -e "${BLUE}${BLOCK_SYMBOL}${WHITE} Block symbol" 