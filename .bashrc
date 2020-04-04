which fortune &>/dev/null && fortune

# VARS
prefix=$(brew --prefix)


# TERM CONFIG
export TERM=screen-256color


# SHELL CONFIG
shopt -s autocd
shopt -s dirspell
shopt -s cdspell
shopt -s cdable_vars
bind Space:magic-space


# PROMT
# using system python for that
export PATH=$PATH:$HOME/Library/Python/2.7/bin
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. $HOME/Library/Python/2.7/lib/python/site-packages/powerline/bindings/bash/powerline.sh


# EDITOR
export EDITOR=kak
export VISUAL=kak

# LANG
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8 &> /dev/null


# HISTORY
export HISTIGNORE="ls:bg:fg:history"
export HISTTIMEFORMAT="%F %T "
export HISTCONTROL="ignoreboth"
shopt -s cmdhist
shopt -s histappend


# ALIASES
alias dev="export ENV=dev"
alias prod="export ENV=prod"
alias tcb="xclip -i -selection clipboard"
alias untar="tar -zxvf "
alias wget="wget -c "
alias diff="colordiff"
alias h="history"
alias jl="jobs -l "
alias ports="netstat -tulanp"
alias bashrc="source ~/.bashrc && echo Bash config reloaded"
alias ls="ls -AlhF --color=auto "
alias of="lsof -nP +c 15 | grep LISTEN"


# FUNC ALIASES & UTILS
ofp() { lsof -nP -iTCP:@1; }
penv() {
  secret=$1;
  target=$2;
  [[ -n "$target" ]] || target=$(basename $secret | tr a-z- A-Z_);
  echo "Setting $target env var to $secret value."
  export $target=$(pass show $secret);
}
dls() {
  docker image ls \
    --format "| {{ .Repository }}:{{ .Tag }} | {{ .ID }} | {{ .Digest }} | {{ .CreatedSince }} |" \
    --filter "reference=gcr.io/$MAIN_GCP_PROJECT/$1";
}


# XDG home for apps like gcloud, kak
export XDG_CONFIG_HOME=$HOME/.config
export GPG_TTY=$(tty)


# K8S
alias k=kubectl
complete -F __start_kubectl k


# PYTHON
export PYTHONSTARTUP=~/.pythonrc


# RBENV
export PATH="$HOME/.rbenv/shims:${PATH}"
export RBENV_SHELL=bash
source '/usr/local/Cellar/rbenv/1.1.2/libexec/../completions/rbenv.bash'
command rbenv rehash 2>/dev/null
rbenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(rbenv "sh-$command" "$@")";;
  *)
    command rbenv "$command" "$@";;
  esac
}


# HOMEBREW
# Homebrew: opt dir
export PATH="$PATH:$(/bin/ls -d $prefix/opt/*/bin | paste -s -d ':' /dev/stdin)"
export LDFLAGS="$LDFLAGS $(/bin/ls -d $prefix/opt/*/lib | paste -s -d ':' /dev/stdin | sed 's/:/ -I/g' | sed 's/^/ -I/')"
export CPPFLAGS="$CPPFLAGS $(/bin/ls -d $prefix/opt/*/include | paste -s -d ':' /dev/stdin | sed 's/:/ -L/g' | sed 's/^/ -L/')"
export BASH_COMPLETION_COMPAT_DIR="$prefix/etc/bash_completion.d"
source "$prefix/etc/profile.d/bash_completion.sh"
# Homebrew: GNU compatibility
export PATH=$(/bin/ls -d $prefix/opt/*/libexec/gnubin | paste -s -d ':' /dev/stdin):$PATH
export MANPATH=$(/bin/ls -d $prefix/opt/*/libexec/gnuman | paste -s -d ':' /dev/stdin):$(manpath)


# FZF
[ -f ~/.fzf.bash ] && . ~/.fzf.bash
# Open in tmux pane if possible
alias fzf="fzf-tmux"
# Faster with ag
if type ag &> /dev/null; then
  export FZF_DEFAULT_COMMAND="ag --silent --hidden --follow -g '' 2> /dev/null"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} 2> /dev/null | head -200'"
revise() {
        local log
        if git log --oneline | grep -q 'origin/master'
        then
                log="git log origin/master..HEAD"
        else
                log="git log -n 10"
        fi
        git revise $($log --oneline --color=always | fzf --ansi --tac | cut -d ' ' -f 1)
}


# JUMP
[[ -s $prefix/etc/autojump.sh ]] && . $prefix/etc/autojump.sh


# GCP SDK
if [ -f $HOME/'google-cloud-sdk/path.bash.inc' ]; then . $HOME/'google-cloud-sdk/path.bash.inc'; fi
# gcloud completion
if [ -f $HOME/'google-cloud-sdk/completion.bash.inc' ]; then . $HOME/'google-cloud-sdk/completion.bash.inc'; fi


# TERRAFORM
alias tf=terraform
complete -C /usr/local/bin/terraform terraform
complete -C /usr/local/bin/terraform tf


# WORK STUFF
[ -r ~/.bashrc.work ] && source ~/.bashrc.work
