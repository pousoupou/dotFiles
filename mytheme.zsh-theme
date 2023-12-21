# run "spectrum_ls" to see the color codes

precmd() {
    # print -rP "%{$fg_bold[cyan]%}%n%{$reset_color%} > %{$fg_bold[cyan]%}%c%{$reset_color%} $(git_prompt_info)"
    print -rP "%{%B$FG[003]%}%1{➜%} %{$fg_bold[cyan]%}%2c%{$reset_color%} $(git_prompt_info)"
}

export PROMPT="%(?:%{$fg_bold[green]%}> :%{%B$FG[088]%}> )"
export RPROMPT="%{$reset_color%}"
# PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
# PROMPT+=' $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
