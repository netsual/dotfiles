# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS SHARE_HISTORY

# Completion
autoload -Uz compinit
compinit

# fzf
export FZF_DEFAULT_OPTS='--height=45% --layout=reverse --border'
alias ff='fzf --walker=file,hidden --walker-skip=.git,node_modules,bin,obj,.venv'

# Git
alias gs='git status --short --branch'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -15'

# Prompt
autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' formats ' · %b%u%c'
zstyle ':vcs_info:git:*' actionformats ' · %b%u%c'

function update_prompt {
    # Save the command status before vcs_info runs.
    local last_status=$?
    local indicator_color=cyan
    (( last_status != 0 )) && indicator_color=red

    vcs_info

    # Git branch names can contain percent signs, which Zsh treats as prompt escapes.
    PROMPT='%F{white}%~%f%F{cyan}'"${vcs_info_msg_0_//\%/%%}"'%f'
    PROMPT+=$'\n'"%F{$indicator_color}❯%f "
}

add-zsh-hook precmd update_prompt
