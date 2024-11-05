# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install VS code
# Install InteliJ apps
# Install GitHub Desktop

# Frontend stuff
brew install nvm
npm install --global yarn

# nvm install stuff
nvm install --lts
nvm use --lts


# Ruby
brew install rbenv
# Add  `eval "$(rbenv init -)"` to profile

# Did I actually run this?
bundle config build.puma --with-cflags="-Wno-error=implicit-function-declaration"


# Golang
brew install golang
zsh < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
gvm install go1.15
gvm install go1.16

# Java
brew install jenv
brew install java
brew install AdoptOpenJDK/openjdk/adoptopenjdk11

# Databases

# postgres (I tried brew but then uninstalled via brew and used the Postgres app to get old versions)
brew install postgres
brew services start postgresql

# make sure to add postgres to PATH in the .bashrc!

# redis
brew install redis
brew services start redis

# AWS cli
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# AWS Session Manager
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip" -o "sessionmanager-bundle.zip"

# saml2aws
brew install saml2aws

# A tool for JSON parsing
brew install jq