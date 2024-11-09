# PATH
export PATH=$PATH:$(go env GOPATH)/bin


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

json-parse-copy() {
  pbpaste | python -mjson.tool | pbcopy
}

open-url() {
  $(python3 ~/bash-profile/helpers/open_url.py $1)
}

# This file
edit-profile() {
  if [ -f ~/.bash_profile ]; then
    vs ~/.bash_profile
    return
  fi
  if [ -f ~/.zshrc ]; then
    vs ~/.zshrc
    return
  fi
  echo "No profile file found!"
}
alias edit-profile-general="vs ~/bash-profile/general.sh"
alias profile-changes-cd="open -a Terminal ~/bash-profile/"
reload-profile() {
  if [ -f ~/.bash_profile ]; then
    source ~/.bash_profile
    return
  fi
  if [ -f ~/.zshrc ]; then
    source ~/.zshrc
    return
  fi
  echo "No profile file found!"
}
alias profile-changes-gui="gui ~/bash-profile/"
profile-changes-push() {
    here=$(pwd)
    cd ~/bash-profile
    git push
    cd $here
}

profile-changes-pull() {
    here=$(pwd)
    cd ~/bash-profile
    git pull
    reload-profile
    cd $here
}

# Makefiles
# Autocomplete makefile targets
#complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make

zstyle ':completion:*:*:make:*' tag-order 'targets'

autoload -U compinit && compinit

# opt-arrow key word breaks
# This is the default without / and -
export WORDCHARS="*?_.[]~=&;!#$%^(){}<>"

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
alias main="git checkout main && git pull"
alias st='open -a SourceTree $(repo-root)'
alias gui='open -a GitHub\ Desktop $(repo-root)'
alias git-amend-and-push="git commit --amend --no-edit && git push --force"
alias git-undo-last-commit="git reset HEAD^"
alias open-repo="open \`git remote -v | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/git@/http:\/\//' -e's/\.git$//' | sed -E 's/(\/\/[^:]*):/\1\//'\`"

alias remote="open \`git remote -v | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/git@/http:\/\//' -e's/\.git$//' | sed -E 's/(\/\/[^:]*):/\1\//'\`"

make-branch() {
  git checkout -b $(python3 ~/bash-profile/helpers/get_issue_branch.py $1)
}

# Ruby
if [ "$(command -v rbenv)" != "" ]; 
then
  eval "$(rbenv init -)"
  alias be="bundle exec"
  alias test="be rspec"
fi

#JetBrains
alias idea='open -na "IntelliJ IDEA.app" --args "."'
alias mine='open -na "RubyMine.app" --args "."'
alias goland='open -na "GoLand.app" --args "."'

alias push-and-stage="git push && stage"
stage() {
  branch=$(git rev-parse --abbrev-ref HEAD)
  echo "************ Branch to stage: $branch"
  if [ "$branch" -eq "staging" ] ; then
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
        read -p "yn?Fixed the conflcts and staged all the changes? (type 'yes' or 'cancel' to reset and go back - WARNING: YOU WILL LOOSE ALL CHANGES) " yn
        case $yn in
          [Yy]* )
            break
            ;;
          cancel )
            git reset --hard HEAD
            git checkout $branch
            echo "************ Cancelled: Nothing's been staged and we are back on $branch"
            return
            ;;
          * )
            echo "Please answer yes."
            ;;
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
