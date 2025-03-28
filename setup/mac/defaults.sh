#!/bin/zsh

# Source common.sh from the same directory as this script
source "$(dirname "$0")/common.sh"
source "$(dirname "$0")/dock_functions.sh"

print_header "Defaults"

print_section "System-wide"
run_command "Disable resume system-wide" "defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false"
run_command "reduce motion" "defaults write NSGlobalDomain ReduceMotion -bool true"

print_section "Siri"
run_command "Disable Siri" "defaults write com.apple.siri EnableAskSiri -bool false"
run_command "Disable Siri in menu bar" "defaults write com.apple.siri StatusMenuVisible -bool false"

print_section "Files"
run_command "Show the Library folder" "chflags nohidden /Library"

print_section "Disk volumes"
run_command "Disable disk image verification" "defaults write com.apple.frameworks.diskimages skip-verify -bool true"
run_command "Disable locked disk image verification" "defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true"
run_command "Disable remote disk image verification" "defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true"
run_command "Auto-open read-only root" "defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true"
run_command "Auto-open read-write root" "defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true"
run_command "Auto-open window for new removable disk" "defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true"

print_section "Network"
run_command "Enable AirDrop over Ethernet" "defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true"

print_section "Battery"
run_command "Hide battery percentage" "defaults write com.apple.menuextra.battery ShowPercent -string NO"
run_command "Show remaining battery time" "defaults write com.apple.menuextra.battery ShowTime -string YES"

print_section "Keyboard"
run_command "Enable full keyboard access" "defaults write NSGlobalDomain AppleKeyboardUIMode -int 3"
run_command "Disable press-and-hold for keys in favor of key repeat" "defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false"
run_command "Set moderate keyboard repeat rate" "defaults write NSGlobalDomain KeyRepeat -int 2"
run_command "Set moderate initial keyboard repeat delay" "defaults write NSGlobalDomain InitialKeyRepeat -int 15"
run_command "Disable auto-correct" "defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false"

print_section "Trackpad"
run_command "Enable tap to click" "defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true"
run_command "Enable tap to click behavior globally" "defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1"
run_command "Enable tap to click behavior" "defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1"
run_command "Set bottom right trackpad corner to right-click" "defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2"
run_command "Enable trackpad right click" "defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true"
run_command "Set trackpad corner click behavior" "defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1"
run_command "Enable secondary click globally" "defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true"

print_section "Monitor"
run_command "Enable subpixel font rendering" "defaults write NSGlobalDomain AppleFontSmoothing -int 2"

print_section "Screen saver"
run_command "Require password after screen saver begins" "defaults write com.apple.screensaver askForPassword -int 1"
run_command "Set no delay for password prompt" "defaults write com.apple.screensaver askForPasswordDelay -int 0"

print_section "Screenshots"
run_command "Disable shadow in screenshots" "defaults write com.apple.screencapture disable-shadow -bool true"

print_section "Menu bar"
run_command "Disable menu bar transparency" "defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false"

print_section "Panels"
run_command "Expand save panel" "defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true"
run_command "Expand print panel" "defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true"

print_section "Dialogs"
run_command "Disable open application confirmation dialog" "defaults write com.apple.LaunchServices LSQuarantine -bool false"

print_section "Windows"
run_command "Disable window animations" "defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false"
run_command "Increase window resize speed" "defaults write NSGlobalDomain NSWindowResizeTime -float 0.001"
run_command "Disable reopen windows on login" "defaults write com.apple.loginwindow TALLogoutSavesState -bool false"
run_command "Disable relaunch apps on login" "defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false"

print_section "Finder"
run_command "Allow quitting via ⌘ + Q" "defaults write com.apple.finder QuitMenuItem -bool true"
run_command "Disable window animations" "defaults write com.apple.finder DisableAllAnimations -bool true"
run_command "Show all filename extensions" "defaults write NSGlobalDomain AppleShowAllExtensions -bool true"
run_command "Show status bar" "defaults write com.apple.finder ShowStatusBar -bool true"
run_command "Enable text selection in Quick Look" "defaults write com.apple.finder QLEnableTextSelection -bool true"
run_command "Show POSIX path in Finder title" "defaults write com.apple.finder _FXShowPosixPathInTitle -bool true"
run_command "Disable .DS_Store on network volumes" "defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true"
run_command "Disable file extension change warning" "defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false"
run_command "Disable Trash empty warning" "defaults write com.apple.finder WarnOnEmptyTrash -bool false"
run_command "Enable secure empty Trash" "defaults write com.apple.finder EmptyTrashSecurely -bool true"

print_section "Desktop"
run_command "Set top left corner to Mission Control" "defaults write com.apple.dock wvous-tl-corner -int 2"
run_command "Set top left corner modifier" "defaults write com.apple.dock wvous-tl-modifier -int 0"
run_command "Set top right corner to Desktop" "defaults write com.apple.dock wvous-tr-corner -int 4"
run_command "Set top right corner modifier" "defaults write com.apple.dock wvous-tr-modifier -int 0"

print_section "Dock apps"

declare -a appsToDock=(
    '/Applications/Qobuz.app'
    '/System/Applications/Notes.app'
    '/Applications/Brave\ Browser.app'
    '/Applications/Bitwarden.app'
    '/Applications/Cursor.app'
    '/Applications/iTerm.app'
    '/Applications/Warp.app'
);
declare -a utilitiesToDock=(
    '/System/Applications/System\ Settings.app'
    '/System/Applications/Utilities/Activity\ Monitor.app'
    '/System/Applications/Utilities/Print\ Center.app'
);
declare -a foldersToDock=(
   # ~/Downloads
);

run_command "Clear dock" "clear_dock"

for app in "${appsToDock[@]}"; do
    run_command "Add $app to dock" "add_app_to_dock $app"
done

run_command "Add spacer to dock" "add_small_spacer_to_dock"

for app in "${utilitiesToDock[@]}"; do
    run_command "Add $app to dock" "add_app_to_dock $app"
done

for folder in "${foldersToDock[@]}"; do
    run_command "Add $folder to dock" "add_folder_to_dock $folder"
done

#run_command "Reset dock" "reset_dock"

print_section "Dock settings"

run_command "Disable recent apps from dock" "disable_recent_apps_from_dock"
run_command "Enable highlight hover effect for grid view" "defaults write com.apple.dock mouse-over-hilte-stack -bool true"
run_command "Enable spring loading for all items" "defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true"
run_command "Show process indicators" "defaults write com.apple.dock show-process-indicators -bool true"
run_command "Disable opening application animations" "defaults write com.apple.dock launchanim -bool false"
run_command "Remove auto-hiding delay" "defaults write com.apple.Dock autohide-delay -float 0"
run_command "Remove hiding animation" "defaults write com.apple.dock autohide-time-modifier -float 0"
run_command "Enable 2D Dock" "defaults write com.apple.dock no-glass -bool true"
run_command "Enable auto-hide" "defaults write com.apple.dock autohide -bool true"
run_command "Make hidden app icons translucent" "defaults write com.apple.dock showhidden -bool true"
run_command "Set minimize animation to scale" "defaults write com.apple.dock mineffect -string scale"
run_command "Set smaller dock size" "defaults write com.apple.dock tilesize -integer 36"


# # Customize Dock
# ## Delete Dock
# defaults write com.apple.dock persistent-apps -array

# # Add system icons
# declare -a sys_icons=(
#     "/Applications/System Settings"
#     "/Volumes/Preboot/Cryptexes/App/System/Applications/Safari"
#     )
# for sys_icon in "${sys_icons[@]}"; do
#     defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/System${sys_icon}.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
# done

# ## Add application icons
# declare -a icons=("Google Chrome" "Slack" "Sourcetree" "IntelliJ IDEA CE" "XCode" "Android Studio" "iTerm" "Postman" "Postgres" "pgAdmin 4")
# for icon in "${icons[@]}"; do
#     if [ -d "/Applications/${icon}.app" ]; then
#         if ! defaults read com.apple.dock | grep "${icon}"; then
#             defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/${icon}.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
#         fi
#     fi
# done



print_section "Dashboard"
run_command "Enable Dashboard dev mode" "defaults write com.apple.dashboard devmode -bool true"

print_section "Time Machine"
run_command "Prevent Time Machine from prompting to use new hard drives" "defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true"

print_section "Terminal"
run_command "Use only UTF-8 in Terminal" "defaults write com.apple.terminal StringEncodings -array 4"
run_command "Create iTerm2 dynamic profiles directory" "mkdir -p $HOME/Library/Application\ Support/iTerm2/DynamicProfiles"
run_command "Copy iTerm2 profiles" "cp -r $HOME/project/dotfiles/configs/iterm-custom.json $HOME/Library/Application\ Support/iTerm2/DynamicProfiles/"
run_command "Install iTerm2 shell integration" "curl -L https://iterm2.com/shell_integration/zsh -o $HOME/.iterm2_shell_integration.zsh"
run_command "Make shell integration executable" "chmod +x $HOME/.iterm2_shell_integration.zsh"
run_command "Run iTerm2 shell integration" "$HOME/.iterm2_shell_integration.zsh"

print_section "iTunes"
run_command "Disable Ping sidebar" "defaults write com.apple.iTunes disablePingSidebar -bool true"
run_command "Disable all Ping functionality" "defaults write com.apple.iTunes disablePing -bool true"
run_command "Set ⌘ + F to focus search input" "defaults write com.apple.iTunes NSUserKeyEquivalents -dict-add 'Target Search Field' '@F'"

appsToKill=(
Finder
Dock
SystemUIServer
cfprefsd
iTerm2
)

print_section "Kill affected applications"
for app in "${appsToKill[@]}"; do
    run_command "Kill $app" "killall $app" warning
done 

check_errors

### NOT USED FOR NOW

# Note: The following command requires Full Disk Access privileges for Terminal.
# To enable this:
# 1. Open System Preferences > Security & Privacy > Privacy
# 2. Select "Full Disk Access" from the left sidebar
# 3. Click the "+" button and add Terminal.app
# 4. Then uncomment and run the following command:
#execute_command "Disable local Time Machine backups" "tmutil disable local"

# print_section "Mail"
# execute_default "Disable reply animations" "defaults write com.apple.Mail DisableReplyAnimations -bool true"
# execute_default "Disable send animations" "defaults write com.apple.Mail DisableSendAnimations -bool true"
# execute_default "Copy email addresses without names" "defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false"


# print_section "Safari"
# execute_default "Disable thumbnail cache for History and Top Sites" "sudo com.apple.Safari DebugSnapshotsUpdatePolicy -int 2"
# execute_default "Enable Safari's debug menu" "sudo com.apple.Safari IncludeInternalDebugMenu -bool true"
# execute_default "Set search banners to Contains instead of Starts With" "sudo com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false"
# execute_default "Remove useless icons from bookmarks bar" "sudo com.apple.Safari ProxiesInBookmarksBar \"()\""
# execute_default "Enable Web Inspector in web views" "NSGlobalDomain WebKitDeveloperExtras -bool true"

# print_section "Address Book"
# execute_default "Enable debug menu in Address Book" "com.apple.addressbook ABShowDebugMenu -bool true"

# print_section "iCal"
# execute_default "Enable debug menu in iCal" "com.apple.iCal IncludeDebugMenu -bool true"
