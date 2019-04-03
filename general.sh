# General
op() {
  if [ ! -f $1 ]; then
    touch $1
  fi
  open -a Atom $1
}

vs() {
  if [ ! -f $1 ]; then
    touch $1
  fi
  open -a "Visual Studio Code" $1
}

json-parse() {
  pbpaste | python -mjson.tool
}

open-url() {
  $(python3 ~/bash-profile/open_url.py $1)
}

# This file
alias edit-profile="op ~/.bash_profile"
alias edit-profile-repo="op ~/bash-profile/general.sh"
alias reload-profile="source ~/.bash_profile"

# Git
alias gut=git
alias got=git
alias gs="git status"
alias gb="git branch"
alias gc="git checkout"
alias gl='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
alias repo-root="git rev-parse --show-toplevel"
alias git-delete-old-branches='git fetch --prune && git branch -r | awk "{print \$1}" | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk "{print \$1}" | xargs git branch -d'
alias staging="git fetch && git branch -D staging && git checkout staging"
alias master="git checkout master && git pull"
alias st='open -a SourceTree $(repo-root)'

# Ruby
alias be="bundle exec"
alias test="be rspec"
alias mine="open -a RubyMine $(repo-root)"

alias push-and-stage="git push && stage"
stage() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  echo "************ Branch to stage: $branch"
  if [ "$branch" == "staging" ] ; then
     echo ":( Switch to the feature branch first (you are on staging!)"
     return
  fi
  git branch -D staging
  git fetch
  git checkout staging
  hopefully_staging=$(git rev-parse --abbrev-ref HEAD)
  if [ "$hopefully_staging" != "staging" ] ; then
     echo ":( Could not checkout staging, stash your local changes first"
     return
  fi
  echo "************ Checked out a fresh staging branch"
  echo "Attempting merge..."
  git merge $branch --no-commit
  while true; do
    conflicts=$(git ls-files -u | wc -l)
    if [ "$conflicts" -gt 0 ] ; then
      echo ":| There are merge conflicts! Please fix them before committing"
      while true; do
        read -p "Fixed the conflcts and staged all the changes? " yn
        case $yn in
          [Yy]* ) break;;
          * ) echo "Please answer yes.";;
        esac
      done
    else
      break;
    fi
  done
  echo "No conflicts. Committing..."
  git commit --no-edit
  echo "************ Feature branch merged into staging"
  git push
  echo "************ Staging branch pushed to origin"
  git checkout $branch
  echo "************ Switched back to feature branch $branch"
  echo "************ $branch was successfully staged!"
}
