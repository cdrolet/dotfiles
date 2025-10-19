
#!/usr/bin/env bash

########################################################################################
# File: fonts.sh
# Description: Font installation and management functions
########################################################################################

source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"
#source "$(dirname "${BASH_SOURCE[0]}")/_commands.sh"

# Function to install fonts from a directory
install_fonts_from_directory() {
    local source_dir="$1"
    local description="${2:-fonts}"
    
    # macOS fonts directory
    local fonts_dir="$HOME/Library/Fonts"
    
    # Count fonts to install
    local font_count=$(find "$source_dir" -type f \( -name "*.ttf" -o -name "*.otf" -o -name "*.TTF" -o -name "*.OTF" \) 2>/dev/null | wc -l | tr -d ' ')
    
    if [ "$font_count" -eq 0 ]; then
        skipped "No fonts found in $source_dir"
        return 0
    fi
    
    # Copy fonts to system fonts directory
    run "Installing $font_count $description" "find '$source_dir' -type f \( -name '*.ttf' -o -name '*.otf' -o -name '*.TTF' -o -name '*.OTF' \) -exec cp {} '$fonts_dir/' \;"
}

# Wrapper function to clone repo and install fonts
install_fonts_from_repo() {
    local repo_url="$1"
    local repo_name=$(basename "$repo_url" .git)
    local target_dir="$HOME/.local/share/fonts/$repo_name"
    
    # Clone or update the repository
    if [ -d "$target_dir" ]; then
        run "Updating $repo_name" "cd '$target_dir' && git pull"
    else
        local parent_dir=$(dirname "$target_dir")
        mkdir -p "$parent_dir"
        spin "Cloning $repo_name" "git clone '$repo_url' '$target_dir'"
    fi
    
    # Install fonts from the repository
    install_fonts_from_directory "$target_dir" "$repo_name fonts"
}