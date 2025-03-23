
xcode-select --install
// check if installation succeed
xcode-select -p

// install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew doctor

brew install python
brew install coreutils


brew install --cask bitwarden
brew install --cask brave-browser

// fonts
brew install --cask font-envy-code-r
brew install --cask font-fira-code
brew install --cask font-source-code-pro


#brew install kubectl
brew install cursor
brew install git   
brew install gh   


cd ~
mkdir project
cd project

gh auth login
// authenticate into github

// dot sync
gh repo clone cdrolet/dotfiles
cd dotfiles 

git submodule update --init --recursive
./dotsync.sh 

// terminals
brew install warp
brew install iterm2

// proton
brew install --cask proton-drive
brew install --cask protonmail-bridge
brew install --cask protonvpn

sudo install code 
