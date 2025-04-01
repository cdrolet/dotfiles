#!/bin/zsh

#######################
# Global Variables
#######################

# Define color codes directly where used to avoid issues with variable expansion
gray='\033[90m'  
white='\033[0m'
red='\033[31m'
green='\033[32m'
yellow='\033[33m'
passed="\033[32m✓\033[0m "
failed="\033[31m✗\033[0m "
warned="\033[33m⚠\033[0m "
successFooter="\n█▀█ █▄▀\n█▄█ █░█\n"
failureFooter="\n█▀▀ ▄▀█ █ █░░ █░█ █▀█ █▀▀\n█▀░ █▀█ █ █▄▄ █▄█ █▀▄ ██▄\n"
# Array to store error messages
errors=()

#######################
# Functions
#######################

print_separator() {
    printf "\n"
    for _ in $(seq 1 "$1"); do
        printf '■'
    done
    printf " $2\n"
}

print_header() {
    local title="$1"
    
    # Minimum length for the bar
    local min_length=10
    
    # Calculate the length of the title
    local title_length=$((2+${#title}))

    # The final bar length is whichever is larger: the title's length or the minimum length
    local bar_length=$(( title_length > min_length ? title_length : min_length ))
    
    # Print a newline before the bar
    printf "\n"
    
    # Print the top bar
    print_separator "$bar_length"

    # Print the title itself, prefixed with "■ "
    printf "■ $title"
    
    # Print the bottom bar
    print_separator "$bar_length"
}

print_section() {
    print_separator 2 "$1"
}

run_command() {
    local description="$1"
    local command="$2"
    local warn_only="$3"
    # Execute the command and capture its output
    if output=$(eval "$command" 2>&1); then
        printf "$passed %s ${gray}%s${white}\n" "$description" "$command"
    else
        if [ "$warn_only" = "warning" ]; then
            printf "$warned %s ${gray}%s${white}\n" "$description" "$command"
        else
            printf "$failed %s ${gray}%s${white}\n" "$description" "$command"
            printf "${red}%s${white}\n" "$output"
            # Add error to global array, taking only first line and limiting to 50 chars
            local first_line=$(echo "$output" | head -n 1)
            local truncated_error="${first_line:0:75}"
            if [ ${#first_line} -gt 50 ] || [ $(echo "$output" | wc -l) -gt 1 ]; then
                truncated_error="${truncated_error}..."
            fi
            errors+=("$description: $truncated_error")
            return 1
        fi
    fi
}


# Function to output all errors and ask for confirmation to continue
check_errors() {
    if [ ${#errors[@]} -gt 0 ]; then
        printf "\n$failureFooter"
        print_separator 30
        printf "\n"
        printf "${yellow}The following errors occurred:${white}\n"
        # Show only first 5 errors
        for i in "${!errors[@]}"; do
            if [ $i -lt 5 ]; then
                printf "${red}- ${errors[$i]}${white}\n"
            elif [ $i -eq 5 ]; then
                local remaining=$(( ${#errors[@]} - 5 ))
                printf "${red}... and %d more errors${white}\n" "$remaining"
                break
            fi
        done
        
        printf "\n"
        read -p "Do you want to continue despite these errors? (y/n): " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            printf "Aborting...\n"
            exit 1
        fi
        
        # Clear errors after confirmation
        errors=()
    else
        printf "\n$successFooter"
        print_separator 30
        printf "\n"
        printf "no errors\n"
    fi
}

# https://github.com/rpavlick/add_to_dock

# adds an application to macOS Dock
# usage: add_app_to_dock "Application Name"
# example add_app_to_dock "/System/Applications/Music.app"
function add_app_to_dock {
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
function add_folder_to_dock {
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

function add_small_spacer_to_dock {
    defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
}

function clear_apps_from_dock {
    defaults delete com.apple.dock persistent-apps
}

function clear_others_from_dock {
    defaults delete com.apple.dock persistent-others
}

function clear_dock {
    clear_apps_from_dock
    clear_others_from_dock
}

function disable_recent_apps_from_dock {
    defaults write com.apple.dock show-recents -bool false
}

function enable_recent_apps_from_dock {
    defaults write com.apple.dock show-recents -bool true
}

function reset_dock {
    defaults delete com.apple.dock
    killall Dock
}

