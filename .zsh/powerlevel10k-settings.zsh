() {
  emulate -L zsh -o extended_glob

  # Avoid full-width lines above the cursor: iTerm2 reflows them on resize,
  # which can leave duplicate prompt lines when Zsh redraws the prompt.
  # https://github.com/romkatv/powerlevel10k#horrific-mess-when-resizing-terminal-window
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
  # The generated dotted style forces even an empty right prompt to fill the line.
  unset POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL
  # Keep all right-side segments, but display them on the command input line.
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    newline
    "${(@)POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS:#newline}"
  )

  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='◀'
}
