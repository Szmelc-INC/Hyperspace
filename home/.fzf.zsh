# ~/.fzf.zsh — fast jump + pretty previews

# If ripgrep exists, use it for CTRL-T and ALT-C sources
if command -v rg >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
  export FZF_ALT_C_COMMAND='rg --hidden --follow --glob "!.git" --type d -n . | sed "s/:.*//" | sort -u'
else
  export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git || find . -type f'
  export FZF_ALT_C_COMMAND='fd -t d --hidden --follow --exclude .git || find . -type d'
fi

# Previewer: bat -> highlight -> plain
if command -v bat >/dev/null 2>&1; then
  PREVIEW='bat --style=plain --color=always --line-range=:500 {}'
elif command -v highlight >/dev/null 2>&1; then
  PREVIEW='highlight -O ansi {} | head -n 500'
else
  PREVIEW='sed -n "1,500p" {}'
fi

export FZF_DEFAULT_OPTS="
  --height 80%
  --layout=reverse
  --border
  --info=inline
  --tabstop=4
  --marker='*'
  --preview-window='right:60%'
  --preview='$PREVIEW'
  --bind='f3:toggle-preview,ctrl-/:toggle-preview'
  --bind='alt-j:down,alt-k:up'
  --bind='ctrl-y:execute-silent(echo -n {+} | xclip -selection clipboard)+abort'
"

# CTRL-T: insert file paths
[[ $- == *i* ]] && source <(fzf --zsh) 2>/dev/null || true

# ALT-C: cd into a directory
fzf-cd-widget() {
  local dir
  dir=$(eval "$FZF_ALT_C_COMMAND" | fzf +m) || return
  printf '%q' "$dir"
}
zle -N fzf-cd-widget
bindkey '^[c' fzf-cd-widget

# CTRL-R: history search with preview
_fzf_history_preview() {
  print -z -- "$BUFFER"
}
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=up:3:wrap"

# Helpers
fsel() { eval "printf '%q\n' $(fzf --multi)"; }        # select files; safe-quoted
fcat() { fzf --multi --preview="$PREVIEW" --bind 'enter:execute(printf %q {} | xargs -r -I{} sh -c \"$PREVIEW\" )'; }

# zoxide integration if present
#if command -v zoxide >/dev/null 2>&1; then
#  eval "$(zoxide init zsh)"
#  zi() { cd "$(zoxide query -i "$@")" || return; }
#fi
