_home() {
  local actions="add rm up ls"
  local packages_list="${XDG_CACHE_HOME:-${HOME}/.cache}/home/packages.list"

  if [[ "${#COMP_WORDS[@]}" -eq 2 ]]; then
    COMPREPLY=($(compgen -W "${actions}" "${COMP_WORDS[${COMP_CWORD}]}"))
  
  elif [[ "${COMP_WORDS[1]}" == "add"  ]]; then
    COMPREPLY=($(compgen -W "$(home ls all)" "${COMP_WORDS[${COMP_CWORD}]}"))
    COMPREPLY+=($(compgen -W "$(home ls all mine)" "${COMP_WORDS[${COMP_CWORD}]}"))

  elif [[ "${COMP_WORDS[1]}" =~ ^(rm|up)$ ]]; then
    COMPREPLY=($(compgen -W "$(home ls)" "${COMP_WORDS[${COMP_CWORD}]}"))
    COMPREPLY+=($(compgen -W "$(home ls mine)" "${COMP_WORDS[${COMP_CWORD}]}"))

  elif [[ "${COMP_WORDS[1]}" == "ls" ]]; then
    if [[ "${#COMP_WORDS[@]}" -eq 3 ]]; then
      COMPREPLY=("all" "mine")
    elif [[ "${#COMP_WORDS[@]}" -eq 4 && "${COMP_WORDS[2]}" == "all" ]]; then
      COMPREPLY=("mine")
    fi
  fi
}
complete -F _home home

