#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH="$HOME/.local/bin:$PATH"

# ---------------------------------------------------------------------------
# Default editor
# ---------------------------------------------------------------------------
export EDITOR=vim
export VISUAL=vim

# ---------------------------------------------------------------------------
# History — bigger, dedup, append across sessions
# ---------------------------------------------------------------------------
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT='%F %T '
shopt -s histappend
shopt -s checkwinsize
shopt -s autocd 2>/dev/null      # type a directory name alone to cd into it
shopt -s cdspell 2>/dev/null     # autocorrect minor typos in cd paths

# ---------------------------------------------------------------------------
# Aliases — modern CLI tools (eza/bat). No icons: no Nerd Font installed.
# ---------------------------------------------------------------------------
alias ls='eza --icons=auto --group-directories-first'
alias ll='eza -lh --icons=auto --group-directories-first --git'
alias la='eza -lah --icons=auto --group-directories-first --git'
alias lt='eza --tree --level=2 --icons=auto --group-directories-first'
alias cat='bat --paging=never'        # syntax highlighting; acts like cat when piped
alias less='bat'                      # paged, highlighted
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias df='df -h'
alias free='free -h'
alias mkdir='mkdir -p'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# git shortcuts
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate -20'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

# ---------------------------------------------------------------------------
# fzf — Ctrl-R fuzzy history, Ctrl-T fuzzy file insert, Alt-C fuzzy cd
# ---------------------------------------------------------------------------
eval "$(fzf --bash)"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'
# preview file contents in Ctrl-T using bat
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"

# ---------------------------------------------------------------------------
# zoxide — smarter cd. Use `z <part-of-dir>` to jump, `zi` to pick interactively.
# ---------------------------------------------------------------------------
eval "$(zoxide init bash)"

# ---------------------------------------------------------------------------
# Prompt — clean two-tone with git branch
# ---------------------------------------------------------------------------
__git_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/.*/ (&)/'
}
PS1='\[\e[1;32m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0;33m\]$(__git_branch)\[\e[0m\] \$ '
