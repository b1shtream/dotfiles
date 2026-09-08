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
# claude — always run inside tmux, so a session survives a dropped ssh/phone
# connection. Default session per project directory: claude-<dirname>.
#
# A *detached* session means a connection dropped -> reattach to it.
# An *attached* session means it is already in use -> start claude-<dirname>-2
# instead, so two terminals never end up driving the same Claude.
#
# Force a brand-new session with:  CLAUDE_TMUX_NEW=1 claude
# Reattach with `cattach` (lists candidates when several exist).
# ---------------------------------------------------------------------------
claude() {
  # Pass straight through when tmux would be wrong or impossible:
  #   $TMUX set      -> already inside tmux; nesting would be confusing
  #   stdout not tty -> being piped/captured by a script
  if [[ -n "$TMUX" || ! -t 1 ]]; then
    command claude "$@"
    return
  fi

  # Headless/one-shot invocations must not be wrapped: their output is the
  # point, and tmux would eat it. -p/--print is Claude's non-interactive mode.
  local a
  for a in "$@"; do
    case "$a" in
      -p|--print|--version|-h|--help|--output-format|update|doctor|mcp|install)
        command claude "$@"
        return
        ;;
    esac
  done

  # Session name from the current directory, sanitised: tmux treats "." and ":"
  # as target separators, so they cannot appear in a session name.
  local base
  base="claude-$(basename "$PWD" | tr -c '[:alnum:]_-' '-' | sed 's/-*$//')"

  # Reattach only to an *unattached* session — the dropped-connection case this
  # wrapper exists for. "=" forces an exact tmux name match, so claude-foo does
  # not prefix-match claude-foo-2.
  if [[ -z "$CLAUDE_TMUX_NEW" ]] \
     && tmux has-session -t "=$base" 2>/dev/null \
     && [[ "$(tmux display-message -p -t "=$base" '#{session_attached}' 2>/dev/null)" == 0 ]]; then
    tmux attach -t "=$base"
    return
  fi

  # Otherwise take the first free name: claude-foo, claude-foo-2, claude-foo-3…
  local name="$base" n=2
  while tmux has-session -t "=$name" 2>/dev/null; do
    name="$base-$n"
    ((n++))
  done

  # Build a properly quoted command so paths with spaces survive.
  local cmd
  printf -v cmd '%q ' "$(command -v claude)" "$@"

  tmux new-session -s "$name" -c "$PWD" "$cmd" \
    || { echo "tmux failed; running claude directly" >&2; command claude "$@"; }
}

# Reattach to a claude session. With an arg, attach to that one. With none,
# attach to this directory's session, or list the candidates if several exist.
cattach() {
  if [[ -n "$1" ]]; then tmux attach -t "=$1"; return; fi
  local base
  base="claude-$(basename "$PWD" | tr -c '[:alnum:]_-' '-' | sed 's/-*$//')"
  local -a found
  mapfile -t found < <(tmux list-sessions -F '#{session_name}' 2>/dev/null \
                        | grep -E "^${base}(-[0-9]+)?$")
  case ${#found[@]} in
    0) echo "no claude session for $PWD — start one with: claude" >&2; return 1 ;;
    1) tmux attach -t "=${found[0]}" ;;
    *) printf 'multiple claude sessions here:\n'
       printf '  %s\n' "${found[@]}"
       printf 'attach with: cattach <name>\n' ;;
  esac
}

# ---------------------------------------------------------------------------
# Prompt — clean two-tone with git branch
# ---------------------------------------------------------------------------
__git_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/.*/ (&)/'
}
PS1='\[\e[1;32m\]\u@\h\[\e[0m\] \[\e[1;34m\]\w\[\e[0;33m\]$(__git_branch)\[\e[0m\] \$ '
