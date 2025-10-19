#!/usr/bin/env bash

########################################################################################
# File: defaults.sh
# Description: Mac system defaults configuration
########################################################################################

SYSTEM_SCRIPT_DIR="$( cd "$( dirname "$(dirname "${BASH_SOURCE[0]}")" )" && pwd )"

#last_stage=true
#verbose=2
#is_simulation=false


source "$SYSTEM_SCRIPT_DIR/lib/_bootstrap.sh"
source "$SYSTEM_SCRIPT_DIR/darwin/_dock_utilities.sh"
source "$SYSTEM_SCRIPT_DIR/darwin/_default_utilities.sh"

sub_header "System Settings"

declare -a appsToStartAtLogin=(
    '/Applications/Weather.app'
    '/Applications/Rectangle.app'
    '/Applications/ProtonVPN.app'
    '/Applications/Proton Mail Bridge.app'
    '/Applications/Proton Drive.app'
);
configure_startup_from_array "appsToStartAtLogin"
run "Start borders" "brew services start borders"

declare -a dockItems=(
    '/Applications/Brave\ Browser.app'
    '/System/Applications/Mail.app'
    '/System/Applications/Maps.app'
    '/Applications/Bitwarden.app'
    '/Applications/Qobuz.app'
    'spacer'
    '/Applications/Cursor.app'
    '/Applications/Ghostty.app'
    '/Applications/Obsidian.app'
    '/Applications/UTM.app'
    'spacer'
    '/System/Applications/System\ Settings.app'
    '/System/Applications/Utilities/Activity\ Monitor.app'
    '/System/Applications/Utilities/Print\ Center.app'
    'spacer'
    '~/Downloads'
);
configure_dock_from_array "dockItems"

declare -A dock_commands=(
    ["Disable recent apps"]="disable_recent_apps_from_dock"
    ["Enable highlight hover effect"]="defaults write com.apple.dock mouse-over-hilte-stack -bool true"
    ["Enable spring loading"]="defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true"
    ["Show indicator lights"]="defaults write com.apple.dock show-process-indicators -bool true"
    ["Disable opening animations"]="defaults write com.apple.dock launchanim -bool false"
    ["Remove auto-hiding delay"]="defaults write com.apple.dock autohide-delay -float 0"
    ["Remove hiding animation"]="defaults write com.apple.dock autohide-time-modifier -float 0"
    ["Enable 2D Dock"]="defaults write com.apple.dock no-glass -bool true"
    ["Enable auto-hide"]="defaults write com.apple.dock autohide -bool true"
    ["Make hidden apps translucent"]="defaults write com.apple.dock showhidden -bool true"
    ["Set minimize animation"]="defaults write com.apple.dock mineffect -string scale"
    ["Set dock size"]="defaults write com.apple.dock tilesize -integer 36"
    ["Minimize to app icon"]="defaults write com.apple.dock minimize-to-application -bool true"
    ["Speed up Mission Control"]="defaults write com.apple.dock expose-animation-duration -float 0.1"
    ["Don't group by app"]="defaults write com.apple.dock expose-group-by-app -bool false"
    ["Don't rearrange Spaces"]="defaults write com.apple.dock mru-spaces -bool false"
    ["Hide the dock"]="defaults write com.apple.dock hide-mirror -bool true"
)
run_command_map "Dock settings" dock_commands defaults_handler

# Standby - Resume
declare -A standby_resume_commands=(
    ["Disable resume system-wide"]="defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false"
    ["Disable resume for system preferences"]="defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false"
    ["Disable resume for Terminal"]="defaults write com.apple.Terminal NSQuitAlwaysKeepsWindows -bool false"
    ["Set standby delay to 24 hours"]="sudo pmset -a standbydelay 86400"
)
run_command_map "Standby - Resume" standby_resume_commands defaults_handler

# Booting
declare -A booting_commands=(
    ["Enable verbose boot"]="sudo nvram boot-args=\"-v\""
    ["Mute sound effects on boot"]="sudo nvram SystemAudioVolume=0"
)
run_command_map "Booting" booting_commands 

# Visual effects
declare -A visual_effects_commands=(
    ["Reduce motion"]="defaults write NSGlobalDomain ReduceMotion -bool true"
    ["Disable window animations"]="defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false"
    ["Accent color to green"]="defaults write NSGlobalDomain AppleHighlightColor -string '0.764700 0.976500 0.568600'"
    ["Set highlight color to green"]="defaults write NSGlobalDomain AppleHighlightColor -string '0.764700 0.976500 0.568600'"
)
run_command_map "Visual effects" visual_effects_commands defaults_handler

# Activity Monitor
declare -A activity_monitor_commands=(
    ["Show all processes"]="defaults write com.apple.ActivityMonitor ShowCategory -int 100"
    ["Sort processes by CPU usage"]="defaults write com.apple.ActivityMonitor SortColumn -string 'CPUUsage'"
    ["Sort processes by CPU usage(2)"]="defaults write com.apple.ActivityMonitor SortDirection -int 0"
    ["Refresh frequency every 2 seconds"]="defaults write com.apple.ActivityMonitor UpdatePeriod -int 2"
)
run_command_map "Activity Monitor" activity_monitor_commands defaults_handler

# Siri
declare -A siri_commands=(
    ["Disable Siri"]="defaults write com.apple.siri EnableAskSiri -bool false"
    ["Disable Siri in menu bar"]="defaults write com.apple.siri StatusMenuVisible -bool false"
)
run_command_map "Siri" siri_commands defaults_handler

# Disk preferences
declare -A disk_preferences=(
    ["Disable disk image verification"]="defaults write com.apple.frameworks.diskimages skip-verify -bool true"
    ["Disable locked disk image verification"]="defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true"
    ["Disable remote disk image verification"]="defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true"
    ["Auto-open read-only root"]="defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true"
    ["Auto-open read-write root"]="defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true"
    ["Auto-open window for new removable disk"]="defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true"
    ["Save to disk (not to iCloud) by default"]="defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false"
    ["Enable debug menu in Disk Utility"]="defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true"
    ["Enable advanced image options in Disk Utility"]="defaults write com.apple.DiskUtility advanced-image-options -bool true"
)
run_command_map "Disk volumes and utilities" disk_preferences defaults_handler

# Network preferences
declare -A network_preferences=(
    ["Enable AirDrop over Ethernet"]="defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true"
)
run_command_map "Network Preferences" network_preferences defaults_handler

# Battery preferences
declare -A battery_preferences=(
    ["Hide battery percentage"]="defaults write com.apple.menuextra.battery ShowPercent -string NO"
    ["Show remaining battery time"]="defaults write com.apple.menuextra.battery ShowTime -string YES"
)
run_command_map "Battery" battery_preferences defaults_handler

# Keyboard preferences
declare -A keyboard_preferences=(
    ["Enable full keyboard access"]="defaults write NSGlobalDomain AppleKeyboardUIMode -int 3"
    ["Disable press-and-hold for keys in favor of key repeat"]="defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false"
    ["Set moderate keyboard repeat rate"]="defaults write NSGlobalDomain KeyRepeat -int 2"
    ["Set moderate initial keyboard repeat delay"]="defaults write NSGlobalDomain InitialKeyRepeat -int 10"
    ["Set french and english languages"]="defaults write NSGlobalDomain AppleLanguages -array 'en-CA' 'fr-CA'"
    ["Set locales"]="defaults write NSGlobalDomain AppleLocale -string 'en_CA'"
    ["Set mesurement units"]="defaults write NSGlobalDomain AppleMeasurementUnits -string 'Metric'"
    ["Set metric units"]="defaults write NSGlobalDomain AppleMetricUnits -bool true"
)
run_command_map "Keyboard" keyboard_preferences defaults_handler

# Trackpad preferences
declare -A trackpad_preferences=(
    ["Enable tap to click"]="defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true"
    ["Enable tap to click behavior globally"]="defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1"
    ["Enable tap to click behavior"]="defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1"
    ["Set bottom right trackpad corner to right-click"]="defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2"
    ["Set bottom right trackpad corner to right-click(2)"]="defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2"
    ["Enable trackpad right click"]="defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true"
    ["Enable trackpad right click globally"]="defaults write NSGlobalDomain com.apple.trackpad.trackpadRightClick -bool true"
    ["Set trackpad corner click behavior"]="defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1"
    ["Enable secondary click globally"]="defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true"
    ["Enable secondary click"]="defaults write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true"
)
run_command_map "Trackpad" trackpad_preferences defaults_handler

# Screen preferences
declare -A screen_preferences=(
    ["Enable subpixel font rendering"]="defaults write NSGlobalDomain AppleFontSmoothing -int 2"
    ["Disable shadow in screenshots"]="defaults write com.apple.screencapture disable-shadow -bool true"
    ["Save screenshots to the desktop"]="defaults write com.apple.screencapture location -string '${HOME}/Desktop'"
    ["Save screenshots in PNG format"]="defaults write com.apple.screencapture type -string 'png'"
    ["Enable HiDPI display modes (non native resolution)"]="sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true"
    ["Disable displays have separate Spaces"]="defaults write com.apple.spaces spans-displays -bool true"

)
run_command_map "Screen" screen_preferences defaults_handler

# Menu bar preferences
declare -A menu_bar_preferences=(
    ["Disable menu bar transparency"]="defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false"
)
run_command_map "Menu bar" menu_bar_preferences defaults_handler

# Side bar preferences
declare -A side_bar_preferences=(
    ["Set sidebar icon size to medium"]="defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2"
)
run_command_map "Side bar" side_bar_preferences defaults_handler

# Scroll bar preferences
declare -A scroll_bar_preferences=(
    ["Always show scrollbars"]="defaults write NSGlobalDomain AppleShowScrollBars -string 'Always'"
    ["Disable 'natural' (Lion-style) scrolling"]="defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false"
)
run_command_map "Scroll bar" scroll_bar_preferences defaults_handler

# Developer mode preferences
declare -A developer_mode_preferences=(
    ["Help viewer in dev mode"]="defaults write com.apple.helpviewer DevMode -bool true"
    ["Show hostname in login window"]="sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName"
    ["Disable smart quotes"]="defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false"
    ["Disable smart dashes"]="defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false"
    ["Enable Dashboard dev mode"]="defaults write com.apple.dashboard devmode -bool true"
)
run_command_map "Developer mode" developer_mode_preferences defaults_handler

# TextEdit preferences
declare -A textedit_preferences=(
    ["Use plain text mode for new TextEdit documents"]="defaults write com.apple.TextEdit RichText -int 0"
    ["Open and save files as UTF-8 in TextEdit"]="defaults write com.apple.TextEdit PlainTextEncoding -int 4"
    ["Open and save files as UTF-8 in TextEdit(2)"]="defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4"
)
run_command_map "TextEdit documents" textedit_preferences defaults_handler

# Windows preferences
declare -A windows_preferences=(
    ["Increase window resize speed"]="defaults write NSGlobalDomain NSWindowResizeTime -float 0.001"
    ["Disable reopen windows on login"]="defaults write com.apple.loginwindow TALLogoutSavesState -bool false"
    ["Disable relaunch apps on login"]="defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false"
    ["Disable open application confirmation dialog"]="defaults write com.apple.LaunchServices LSQuarantine -bool false"
    ["Expand save panel"]="defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true"
    ["Expand save panel(2)"]="defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true"
    ["Move windows by dragging any part(ctrl + cmd)"]="Defaults write -g NSWindowShouldDragOnGesture -bool true"
)
run_command_map "Windows" windows_preferences defaults_handler

# Finder preferences
declare -A finder_preferences=(
    ["Sort folders first"]="defaults write com.apple.finder _FXSortFoldersFirst -bool true"
    ["Allow quitting via ⌘ + Q"]="defaults write com.apple.finder QuitMenuItem -bool true"
    ["Disable window animations"]="defaults write com.apple.finder DisableAllAnimations -bool true"
    ["Show all files"]="defaults write com.apple.finder AppleShowAllFiles -bool true"
    ["Show all filename extensions"]="defaults write NSGlobalDomain AppleShowAllExtensions -bool true"
    ["Show status bar"]="defaults write com.apple.finder ShowStatusBar -bool true"
    ["Show path bar"]="defaults write com.apple.finder ShowPathbar -bool true"
    ["Allow text selection in Quick Look"]="defaults write com.apple.finder QLEnableTextSelection -bool true"
    ["Show POSIX path in title"]="defaults write com.apple.finder _FXShowPosixPathInTitle -bool true"
    ["Disable .DS_Store on network volumes"]="defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true"
    ["Disable file extension change warning"]="defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false"
    ["Disable Trash empty warning"]="defaults write com.apple.finder WarnOnEmptyTrash -bool false"
    ["Enable secure empty Trash"]="defaults write com.apple.finder EmptyTrashSecurely -bool true"
    ["Open in list view"]="defaults write com.apple.finder FXPreferredViewStyle -string 'Nlsv'"
    ["When performing a search, search the current folder by default"]="defaults write com.apple.finder FXDefaultSearchScope -string 'SCcf'"
    ["Enable spring loading for directories"]="defaults write NSGlobalDomain com.apple.springing.enabled -bool true"
    ["Remove the spring loading delay for directories"]="defaults write NSGlobalDomain com.apple.springing.delay -float 0"
    ["Expand the following File Info panes: General,Open with and Sharing & Permissions"]="defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true"
)
run_command_map "Finder" finder_preferences defaults_handler

# Desktop preferences
declare -A desktop_preferences=(
    ["Set top left corner to Mission Control"]="defaults write com.apple.dock wvous-tl-corner -int 2"
    ["Set top left corner to Mission Control(2)"]="defaults write com.apple.dock wvous-tl-modifier -int 0"
    ["Set top right corner to Desktop"]="defaults write com.apple.dock wvous-tr-corner -int 4"
    ["Set top right corner to Desktop(2)"]="defaults write com.apple.dock wvous-tr-modifier -int 0"
    ["Hide icons for external media on the desktop"]="defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false"
    ["Hide icons for hard drives on the desktop"]="defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false"
    ["Hide icons for mounted servers on the desktop"]="defaults write com.apple.finder ShowMountedServersOnDesktop -bool false"
    ["Hide icons for removable media on the desktop"]="defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false"
)
run_command_map "Desktop" desktop_preferences defaults_handler

# Terminal preferences
declare -A terminal_preferences=(
    ["Use only UTF-8 in Terminal"]="defaults write com.apple.terminal StringEncodings -array 4"
    ["hover over and start typing without clicking first"]="defaults write com.apple.terminal FocusFollowsMouse -bool true"
)
run_command_map "Terminal" terminal_preferences defaults_handler

# Printing preferences
declare -A printing_preferences=(
    ["Automatically quit printer app once the print jobs complete"]="defaults write com.apple.print.PrintingPrefs 'Quit When Finished' -bool true"
    ["Expand print panel"]="defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true"
    ["Expand print panel(2)"]="defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true"
)
run_command_map "Printing" printing_preferences defaults_handler

# Security preferences
declare -A security_preferences=(
    ["Disable guest account login"]="sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false"
    ["Check for software updates daily, not just once per week"]="defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1"
    ["Require password after screen saver begins"]="defaults write com.apple.screensaver askForPassword -int 1"
    ["Set no delay for password prompt"]="defaults write com.apple.screensaver askForPasswordDelay -int 0"
)
run_command_map "Security" security_preferences defaults_handler

# Privacy preferences
declare -A privacy_preferences=(
    ["Disable crash reporter"]="defaults write com.apple.CrashReporter DialogType -string 'none'"
    ["Disable diagnostic reports"]="defaults write com.apple.SubmitDiagInfo.plist AutoSubmit -bool false"
)
run_command_map "Privacy" privacy_preferences defaults_handler

# Firewall preferences
declare -A firewall_preferences=(
    ["Enable firewall"]="sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1"
    ["Enable firewall stealth mode"]="sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -int 1"
    ["Enable firewall logging"]="sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -int 1"
)
run_command_map "Firewall" firewall_preferences defaults_handler

# Messages preferences
declare -A messages_preferences=(
    ["Disable automatic emoji substitution (i.e. use plain text smileys)"]="defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add 'automaticEmojiSubstitutionEnablediMessage' -bool false"
    ["Disable smart quotes"]="defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add 'automaticQuoteSubstitutionEnabled' -bool false"
)
run_command_map "Messages" messages_preferences defaults_handler

# Calculator preferences
declare -A calculator_preferences=(
    ["Open in programmer view"]="defaults write com.apple.Calculator ShowProgrammer -bool true"
    ["Set input base 10"]="defaults write com.apple.Calculator CurrentInputBase -int 10"
    ["Show thousand separator"]="defaults write com.apple.Calculator SeparatorsDefaultsKey -int 1"
)
run_command_map "Calculator" calculator_preferences defaults_handler

# iTunes preferences
declare -A itunes_preferences=(
    ["Disable Ping sidebar"]="defaults write com.apple.iTunes disablePingSidebar -bool true"
    ["Disable all Ping functionality"]="defaults write com.apple.iTunes disablePing -bool true"
    ["Set ⌘ + F to focus search input"]="defaults write com.apple.iTunes NSUserKeyEquivalents -dict-add 'Target Search Field' '@F'"
    ["Stop iTunes from responding to the keyboard media keys"]="defaults write com.apple.rcd.plist RCAppControlEnabled -bool false"
)
run_command_map "iTunes" itunes_preferences defaults_handler

# Mail preferences
declare -A mail_preferences=(
    ["Disable reply animations"]="sudo defaults write com.apple.mail DisableReplyAnimations -bool true"
    ["Disable send animations"]="sudo defaults write com.apple.mail DisableSendAnimations -bool true"
    ["Copy email addresses as 'foo@example.com' instead of 'Foo Bar <foo@example.com>'"]="sudo defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false"
    ["Add the keyboard shortcut ⌘ + Enter to send an email"]='sudo defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" -string "@\\U21a9"'
    ["Display emails in threaded mode, sorted by date"]="sudo defaults write com.apple.mail DraftsViewerAttributes -dict-add 'DisplayInThreadedMode' -string 'yes'"
    ["Display emails in threaded mode, sorted by date(2)"]="sudo defaults write com.apple.mail DraftsViewerAttributes -dict-add 'SortedDescending' -string 'yes'"
    ["Display emails in threaded mode, sorted by date(3)"]="sudo defaults write com.apple.mail DraftsViewerAttributes -dict-add 'SortOrder' -string 'received-date'"
    ["Disable inline attachments"]="sudo defaults write com.apple.mail DisableInlineAttachmentViewing -bool true"
    ["Disable automatic spell checking"]="sudo defaults write com.apple.mail SpellCheckingBehavior -string 'NoSpellCheckingEnabled'"
)
run_command_map "Mail" mail_preferences defaults_handler
#rwarn "Kill Mail" "killall Mail"

# Safari preferences
declare -A safari_preferences=(
    ["Enable debug menu"]="sudo defaults write com.apple.Safari IncludeInternalDebugMenu -bool true"
    ["Enable develop menu and web inspector"]="sudo defaults write com.apple.Safari IncludeDevelopMenu -bool true"
    ["Enable WebKit developer extras"]="sudo defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true"
    ["Enable WebKit developer extras(2)"]="sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true"
    ["Disable thumbnail cache for History and Top Sites"]="sudo defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2"
    ["Set search banners to Contains instead of Starts With"]="sudo defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false"
    ["Enable Web Inspector in web views"]="sudo defaults write NSGlobalDomain WebKitDeveloperExtras -bool true"
    ["Set home page to 'about:blank' for faster loading"]="sudo defaults write com.apple.Safari HomePage -string 'about:blank'"
    ["Prevent from opening 'safe' files automatically after downloading"]="sudo defaults write com.apple.Safari AutoOpenSafeDownloads -bool false"
    ["Allow hitting the Backspace key to go to previous page in history"]="sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true"
    ["Hide bookmarks bar by default"]="sudo defaults write com.apple.Safari ShowFavoritesBar -bool false"
    ["Hide sidebar in Top Sites"]="sudo defaults write com.apple.Safari ShowSidebarInTopSites -bool false"
)
run_command_map "Safari" safari_preferences defaults_handler

# Address Book preferences
declare -A address_book_preferences=(
    ["Enable debug menu"]="sudo defaults write com.apple.addressbook ABShowDebugMenu -bool true"
)
run_command_map "Address Book" address_book_preferences defaults_handler

# iCal preferences
declare -A ical_preferences=(
    ["Enable debug menu"]="defaults write com.apple.iCal IncludeDebugMenu -bool true"
)
run_command_map "iCal" ical_preferences defaults_handler

# Time Machine preferences
declare -A time_machine_preferences=(
    ["Prevent prompting to use new hard drives"]="defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true"
)
run_command_map "Time Machine" time_machine_preferences defaults_handler

# Mac App Store preferences
declare -A mac_app_store_preferences=(
    ["Enable the WebKit Developer Tools"]="defaults write com.apple.appstore WebKitDeveloperExtras -bool true"
    ["Enable Debug Menu"]="defaults write com.apple.appstore ShowDebugMenu -bool true"
)
run_command_map "Mac App Store" mac_app_store_preferences defaults_handler

section "Spotlight"
run "Change indexing order and disable some file types from being indexed" "defaults write com.apple.spotlight orderedItems -array \
  '{"enabled" = 1;"name" = "APPLICATIONS";}' \
  '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
  '{"enabled" = 1;"name" = "DIRECTORIES";}' \
  '{"enabled" = 1;"name" = "PDF";}' \
  '{"enabled" = 1;"name" = "FONTS";}' \
  '{"enabled" = 0;"name" = "DOCUMENTS";}' \
  '{"enabled" = 0;"name" = "MESSAGES";}' \
  '{"enabled" = 0;"name" = "CONTACT";}' \
  '{"enabled" = 0;"name" = "EVENT_TODO";}' \
  '{"enabled" = 0;"name" = "IMAGES";}' \
  '{"enabled" = 0;"name" = "BOOKMARKS";}' \
  '{"enabled" = 0;"name" = "MUSIC";}' \
  '{"enabled" = 0;"name" = "MOVIES";}' \
  '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
  '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
  '{"enabled" = 0;"name" = "SOURCE";}'" defaults_handler

# Files
declare -a file_extensions=(
    ".c"
    ".cpp"
    ".js"
    ".jsx"
    ".ts"
    ".tsx"
    ".json"
    ".md"
    ".sql"
    ".css"
    ".scss"
    ".sass"
    ".py"
    ".sum"
    ".rs"
    ".go"
    ".sh"
    ".log"
    ".toml"
    ".yml"
    ".yaml"
    ".php"
    ".rb"
    ".swift"
    ".xml"
    "public.plain-text"
    "public.unix-executable"
    "public.data"
)
run_commands "Files" file_extensions "{param} using Cursor as default editor" "duti -s com.cursor.Cursor {param} all"
run "Show the Library folder" "chflags nohidden /Library"

declare -a appsToKill=(
Finder
Dock
AddressBook
Activity Monitor
Calendar
Calculator
iCal
Contacts
Terminal
Mail
Messages
SystemUIServer
cfprefsd
)

section "Kill affected applications"
for app in "${appsToKill[@]}"; do
    rwarn "Kill $app" "killall $app"
done 

run "Make sure indexing is enabled for the main volume" "sudo mdutil -i on /"

unset SYSTEM_SCRIPT_DIR