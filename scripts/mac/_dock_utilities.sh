#!/usr/bin/env bash

configure_startup_from_array() {
    local -n items="$1"

    section "Startup Applications"
    
    for app in "${items[@]}"; do
        if check_app_exists "$app"; then
            run "Enable $app to start automatically" "osascript -e 'tell application \"System Events\" to make login item at end with properties {name: \"$(basename "$app" .app)\", path:\"$app\"}'"
        else
            warning "App not found: $app"
        fi
    done
}

configure_dock_from_array() {
    local -n items="$1"
    
    section "Dock Configuration"
    clear_dock
    
    for item in "${items[@]}"; do
        if [ "$item" = "spacer" ]; then
            add_small_spacer_to_dock
        else
            local expanded_path="${item/#\~/$HOME}"
            
            if [[ "$item" == *.app ]]; then
                if check_app_exists "$item"; then
                    run "Add $item to dock" "add_app_to_dock $item"
                else
                    warning "App not found: $item"
                fi
            elif [ -d "$expanded_path" ]; then
                run "Add $expanded_path to dock" "add_folder_to_dock $expanded_path"
            else
                warning "Item not found: $item"
            fi
        fi
    done
}

# Function to check if an app path exists
check_app_exists() {
    local app_path="$1"
    # Remove backslashes before spaces to get the actual path
    local clean_path=$(echo "$app_path" | sed 's/\\//g')
    if [ -e "$clean_path" ]; then
        return 0  # App exists
    else
        return 1  # App doesn't exist
    fi
}

###################################################################

# https://github.com/rpavlick/add_to_dock
# adds an application to macOS Dock
# usage: add_app_to_dock "Application Name"
# example add_app_to_dock "/System/Applications/Music.app"
add_app_to_dock() {
    app="${1}"

    if open -Ra "${app}"; then
        echo "$app added to the Dock."

        defaults write com.apple.dock persistent-apps -array-add "<dict>
                <key>tile-data</key>
                <dict>
                    <key>file-data</key>
                    <dict>
                        <key>_CFURLString</key>
                        <string>${app}</string>
                        <key>_CFURLStringType</key>
                        <integer>0</integer>
                    </dict>
                </dict>
            </dict>"
    else
        echo "ERROR: Application $1 not found."
    fi
}

# adds a folder to macOS Dock
# usage: add_folder_to_dock "Folder Path" -a n -d n -v n
# example: add_folder_to_dock "~/Downloads" -a 2 -d 0 -v 1
# key:
# -a or --arrangement
#   1 -> Name
#   2 -> Date Added
#   3 -> Date Modified
#   4 -> Date Created
#   5 -> Kind
# -d or --displayAs
#   0 -> Stack
#   1 -> Folder
# -v or --showAs
#   0 -> Automatic
#   1 -> Fan
#   2 -> Grid
#   3 -> List
add_folder_to_dock() {
    folder="${1}"
    arrangement="1"
    displayAs="0"
    showAs="0"

    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -a|--arrangement)
                if [[ $2 =~ ^[1-5]$ ]]; then
                    arrangement="${2}"
                fi
                ;;
            -d|--displayAs)
                if [[ $2 =~ ^[0-1]$ ]]; then
                    displayAs="${2}"
                fi
                ;;
            -v|--showAs)
                if [[ $2 =~ ^[0-3]$ ]]; then
                    showAs="${2}"
                fi
                ;;
        esac
        shift
    done

    if [ -d "$folder" ]; then
        echo "$folder added to the Dock."

        defaults write com.apple.dock persistent-others -array-add "<dict>
                <key>tile-data</key>
                <dict>
                    <key>arrangement</key>
                    <integer>${arrangement}</integer>
                    <key>displayas</key>
                    <integer>${displayAs}</integer>
                    <key>file-data</key>
                    <dict>
                        <key>_CFURLString</key>
                        <string>file://${folder}</string>
                        <key>_CFURLStringType</key>
                        <integer>15</integer>
                    </dict>
                    <key>file-type</key>
                    <integer>2</integer>
                    <key>showas</key>
                    <integer>${showAs}</integer>
                </dict>
                <key>tile-type</key>
                <string>directory-tile</string>
            </dict>"
    else
        echo "ERROR: Folder $folder not found."
    fi
}

add_small_spacer_to_dock() {
    run "Add small spacer to dock" "defaults write com.apple.dock persistent-apps -array-add '{\"tile-type\"=\"small-spacer-tile\";}'"
}

clear_dock() {
    # Create empty arrays for both persistent-apps and persistent-others
    run "Clear dock" "defaults write com.apple.dock persistent-apps -array"
    run "Clear others from dock" "defaults write com.apple.dock persistent-others -array"
}

disable_recent_apps_from_dock() {
    run "Disable recent apps from dock" "defaults write com.apple.dock show-recents -bool false"
}

enable_recent_apps_from_dock() {
    run "Enable recent apps from dock" "defaults write com.apple.dock show-recents -bool true"
}

