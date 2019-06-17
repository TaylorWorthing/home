_home() {
  local actions="add rm up ls"
  # Actions should only complete as the first argument
  if [[ "${#COMP_WORDS[@]}" -eq 2 ]]; then
    COMPREPLY=($(compgen -W "${actions}" "${COMP_WORDS[${COMP_CWORD}]}"))
    return
  fi
  
  # If the first argument is `rm` or `up`, use package names for completions
  if [[ "${COMP_WORDS[1]}" =~ ^(rm|up)$ ]]; then
    COMPREPLY=($(compgen -W "$(home ls)" "${COMP_WORDS[${COMP_CWORD}]}"))
  fi
}
complete -F _home home

