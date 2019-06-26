_home() {
  local actions="add rm up ls"
  local packages_list="${XDG_CACHE_HOME:-${HOME}/.cache}/home/packages.list"

  if [[ "${#COMP_WORDS[@]}" -eq 2 ]]; then
    COMPREPLY=($(compgen -W "${actions}" "${COMP_WORDS[${COMP_CWORD}]}"))
    return
  fi
  
  if [[ "${COMP_WORDS[1]}" == "add"  ]]; then
    if [[ -f "${packages_list}" ]]; then
      COMPREPLY=($(compgen -W "$(<"${packages_list}")" "${COMP_WORDS[${COMP_CWORD}]}"))
    fi

  elif [[ "${COMP_WORDS[1]}" =~ ^(rm|up)$ ]]; then
    COMPREPLY=($(compgen -W "$(home ls)" "${COMP_WORDS[${COMP_CWORD}]}"))
    COMPREPLY+=($(compgen -W "$(home ls mine)" "${COMP_WORDS[${COMP_CWORD}]}"))

  elif [[ "${COMP_WORDS[1]}" == "ls" ]]; then
    COMPREPLY="mine"
  fi
}
complete -F _home home

