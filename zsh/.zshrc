# History and completion
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS SHARE_HISTORY

autoload -Uz compinit
compinit

# Shortcuts
alias gs='git status --short --branch'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -15'
alias ff='fzf'

# Prompt: path, Git branch, staged (+) and unstaged (*) tracked changes.
autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' formats ' · %b%c%u'
zstyle ':vcs_info:git:*' actionformats ' · %b%c%u (%a)'
setopt PROMPT_PERCENT
unsetopt PROMPT_SUBST

update_prompt() {
    local last_status=$?
    local git_text='' indicator_color=cyan

    if (( $+commands[git] )); then
        vcs_info
        # Git names are data, not prompt percent escapes or shell expressions.
        git_text=${vcs_info_msg_0_//\%/%%}
    fi
    if (( last_status != 0 )); then
        indicator_color=red
    fi

    PROMPT="%F{white}%~%f%F{cyan}${git_text}%f"$'\n'"%F{${indicator_color}}❯%f "
}
add-zsh-hook precmd update_prompt

# Native tool integrations (fzf 0.48.0+); both are optional.
if (( $+commands[fzf] )); then
    source <(fzf --zsh)
fi

if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
fi
