#!/usr/bin/env bash

########################################################################################
# File: set-defaults.sh
# Description: Set default applications for file types and URL schemes
########################################################################################

# Get script directory and load utilities
DEFAULTS_SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

source "$DEFAULTS_SCRIPT_DIR/../lib/_bootstrap.sh"
source "$DEFAULTS_SCRIPT_DIR/_install_utilities.sh"

sub_header "Setting Default Applications"

# Zen Browser - Web content
# Note: HTML/XHTML file associations are protected by macOS and cannot be set via duti
# Use System Settings > Desktop & Dock > Default web browser or Finder > Get Info to set these manually
declare -A zen_web_associations=(
    ["HTTP protocol"]="http"
    ["HTTPS protocol"]="https"
)
set_default_apps "Zen Browser" "app.zen-browser.zen" zen_web_associations

# Zed - Programming files (GUI IDE for projects)
declare -A zed_programming_associations=(
    ["JavaScript files"]=".js"
    ["JSX files"]=".jsx"
    ["TypeScript files"]=".ts"
    ["TSX files"]=".tsx"
    ["JSON files"]=".json"
    ["Python files"]=".py"
    ["Rust files"]=".rs"
    ["Go files"]=".go"
    ["C files"]=".c"
    ["C++ files"]=".cpp"
    ["Java files"]=".java"
    ["Ruby files"]=".rb"
    ["PHP files"]=".php"
    ["Swift files"]=".swift"
    ["CSS files"]=".css"
    ["SCSS files"]=".scss"
    ["Sass files"]=".sass"
    ["SQL files"]=".sql"
    ["XML files"]=".xml"
)
set_default_apps "Zed (Projects)" "dev.zed.Zed" zed_programming_associations

# Helix - Text & config files (terminal editor for quick edits)
declare -A helix_text_associations=(
    ["Text files"]=".txt"
    ["Markdown files"]=".md"
    ["Shell scripts"]=".sh"
    ["Bash scripts"]=".bash"
    ["Zsh scripts"]=".zsh"
    ["TOML files"]=".toml"
    ["YAML files"]=".yml"
    ["YAML files (alt)"]=".yaml"
    ["Config files"]=".conf"
    ["Log files"]=".log"
    ["Plain text (UTI)"]="public.plain-text"
    ["Unix executables"]="public.unix-executable"
    ["Shell scripts (UTI)"]="public.shell-script"
    ["Data files"]="public.data"
)
set_default_apps "Helix (Quick Edits)" "dev.helix-editor.helix" helix_text_associations

success "Default applications configured successfully!"

unset DEFAULTS_SCRIPT_DIR
