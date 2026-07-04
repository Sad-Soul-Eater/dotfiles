#!/usr/bin/env zsh

ZINIT_HOME="${HOME}/.zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone --depth 1 --single-branch 'https://github.com/zdharma-continuum/zinit.git' "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

export _ZO_DOCTOR=0

# PATHs
typeset -U path PATH
path=(
  $HOME/.local/bin(N/)
  $HOME/.cargo/bin(N/)
  $HOME/go/bin(N/)
  $HOME/google-cloud-sdk/bin(N/)
  ${KREW_ROOT:-$HOME/.krew}/bin(N/)
  ${HOMEBREW_PREFIX:=/opt/homebrew}/opt/grep/libexec/gnubin(N/)
  ${HOMEBREW_PREFIX:=/opt/homebrew}/opt/curl/bin(N/)
  $path
)

zinit depth"1" lucid light-mode for \
  id-as'iTerm2-shell-integration' \
    atload'PATH+=:$(pwd)/utilities'\
    pick"shell_integration/zsh" \
    if"[[ $LC_TERMINAL == iTerm2 || $+ITERM_PROFILE ]]" \
    @gnachman/iTerm2-shell-integration

# Prompt
for prompt_config in "$HOME/.zsh/powerlevel10k-generated.zsh" "$HOME/.zsh/powerlevel10k-settings.zsh"; do
  zinit ice link light-mode
  if [[ -r "$prompt_config" ]]; then
    zinit snippet "$prompt_config"
  else
    zinit snippet "https://github.com/Sad-Soul-Eater/dotfiles/raw/master/.zsh/$prompt_config"
  fi
done

zinit depth'1' nocd light-mode for \
  id-as'powerlevel10k' \
    @romkatv/powerlevel10k

# Secrets
if [[ -r "$HOME/.zsh/secrets.zsh" ]]; then
  zinit ice link light-mode
  zinit snippet "$HOME/.zsh/secrets.zsh"
fi

# Oh My Zsh libs
# https://github.com/ohmyzsh/ohmyzsh/tree/master/lib
zinit light-mode for \
  OMZL::clipboard.zsh \
  OMZL::completion.zsh \
  OMZL::correction.zsh \
  OMZL::directories.zsh \
  OMZL::functions.zsh \
  OMZL::git.zsh \
  OMZL::grep.zsh \
  OMZL::history.zsh \
  OMZL::key-bindings.zsh \
  OMZL::spectrum.zsh \
  OMZL::termsupport.zsh

# Programs
zinit as'program' depth'1' lucid light-mode for \
  id-as'fzf' \
    from'gh-r' \
    @junegunn/fzf \
  id-as'zoxide' \
    from'gh-r' \
    @ajeetdsouza/zoxide \
  id-as'f2' \
    from'gh-r' \
    cp'scripts/completions/f2.zsh -> _f2' \
    pick'f2' \
    @ayoisaiah/f2 \
  id-as'topgrade' \
    from'gh-r' \
    @topgrade-rs/topgrade

# Programs that not working in Termux
zinit as'program' depth'1' lucid light-mode if'[[ -z "$TERMUX_VERSION" ]]' for \
  id-as'lsd' \
    from'gh-r' \
    mv'lsd*/lsd -> .' \
    cp'lsd*/*/_lsd -> .' \
    @lsd-rs/lsd \
  id-as'atuin' \
    from'gh-r' \
    bpick'atuin-(X86_64|aarch64)*.tar.gz' \
    mv'atuin*/atuin -> atuin' \
    atclone'./atuin gen-completions --shell zsh > _atuin' \
    atpull'%atclone' \
    @atuinsh/atuin \
  id-as'direnv' \
    from'gh-r' \
    mv'direnv* -> direnv' \
    atclone'chmod +x ./direnv' \
    atpull'%atclone' \
    @direnv/direnv \
  id-as'bat' \
    from'gh-r' \
    mv'bat*/bat -> bat' \
    cp'bat*/autocomplete/bat.zsh -> _bat' \
    @sharkdp/bat \
  id-as'fd' \
    from'gh-r' \
    mv'fd*/fd -> .' \
    cp'fd*/*/_fd -> .' \
    @sharkdp/fd \
  id-as'delta' \
    from'gh-r' \
    mv'delta*/delta -> delta' \
    atclone'./delta --generate-completion zsh > _delta' \
    atpull'%atclone' \
    @dandavison/delta \
  id-as'ripgrep' \
    from'gh-r' \
    mv'ripgrep*/rg -> .' \
    cp'ripgrep*/*/_rg -> .' \
    @BurntSushi/ripgrep \
  id-as'dust' \
    from'gh-r' \
    mv'dust*/dust -> dust' \
    @bootandy/dust \
  id-as'sd' \
    from'gh-r' \
    mv'sd*/sd -> .' \
    cp'sd*/*/_sd -> .' \
    @chmln/sd \
  id-as'lazygit' \
    from'gh-r' \
    @jesseduffield/lazygit \
  id-as'kubecolor' \
    has'kubectl' \
    from'gh-r' \
    atclone'./kubecolor completion zsh | sed "s/kubectl/kubecolor/g" > _kubecolor' \
    atpull'%atclone' \
    @kubecolor/kubecolor \
  id-as'cilium-cli' \
    has'kubectl' \
    from'gh-r' \
    atclone'./cilium completion zsh > _cilium' \
    atpull'%atclone' \
    @cilium/cilium-cli \
  id-as'kubeseal' \
    has'kubectl' \
    from'gh-r' \
    @bitnami/sealed-secrets \
  id-as'k9s' \
    has'kubectl' \
    from'gh-r' \
    atclone'./k9s completion zsh > _k9s' \
    atpull'%atclone' \
    @derailed/k9s \
  id-as'talosctl' \
    has'kubectl' \
    from'gh-r' \
    mv'talosctl* -> talosctl' \
    atclone'chmod +x ./talosctl && ./talosctl completion zsh > _talosctl' \
    atpull'%atclone' \
    @siderolabs/talos

# Google Cloud SDK completion
_ZSHRC_GCLOUD_COMPLETION_FILE="${HOME}/google-cloud-sdk/completion.zsh.inc"
if [[ -r "$_ZSHRC_GCLOUD_COMPLETION_FILE" ]]; then
  zinit ice id-as"google-cloud-sdk-completion" wait'0a' lucid link light-mode
  zinit snippet "$_ZSHRC_GCLOUD_COMPLETION_FILE"
fi

# Dynamic programs init
typeset -A sys_inits=(
  [atuin]="atuin init zsh"
  [direnv]="direnv hook zsh"
  [fzf]="fzf --zsh"
  [zoxide]="zoxide init zsh"
)
typeset -A sys_comps=(
  [uv]="uv generate-shell-completion zsh"
  [uvx]="uvx --generate-shell-completion zsh"
)
zinit wait'0a' lucid light-mode for \
  id-as'system-inits' \
    atinit'
      local pdir="$(pwd)"

      # Handle init scripts
      for cmd in ${(k)sys_inits}; do
        if (( $+commands[$cmd] )); then
          if [[ ! -f "$pdir/${cmd}.init.zsh" ]]; then
            eval "${sys_inits[$cmd]} >! $pdir/${cmd}.init.zsh"
            zcompile "$pdir/${cmd}.init.zsh"
          fi
          source "$pdir/${cmd}.init.zsh"
        fi
      done

      # Handle completions
      for cmd in ${(k)sys_comps}; do
        if (( $+commands[$cmd] )); then
          if [[ ! -f "$pdir/_${cmd}" ]]; then
            eval "${sys_comps[$cmd]} >! $pdir/_${cmd}"
          fi
        fi
      done
    ' \
    atpull'rm -f "$(pwd)"/*.init.zsh "$(pwd)"/*.zwc "$(pwd)"/_* 2>/dev/null | true' \
    run-atpull \
    @zdharma-continuum/null

zinit wait'0a' depth'1' lucid light-mode for \
  id-as'zsh-completions' \
    blockf \
    atpull'zinit creinstall -q .' \
    atinit'zicompinit; zicdreplay' \
    @zsh-users/zsh-completions

# Oh My Zsh plugins
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
zinit wait'0b' lucid light-mode for \
  OMZP::colored-man-pages \
  OMZP::extract \
  OMZP::git \
  OMZP::sudo \
  OMZP::systemd

zinit depth'1' wait'0b' lucid light-mode for \
  id-as'history-search-multi-word' \
    if'[[ -z "$commands[atuin]" ]]' \
    @zdharma-continuum/history-search-multi-word \
  id-as'forgit' \
    @wfxr/forgit \
  id-as'zsh-you-should-use' \
    @MichaelAquilina/zsh-you-should-use \
  id-as'fzf-tab' \
    @Aloxaf/fzf-tab

zinit depth'1' wait'0c' lucid light-mode for \
  id-as'fast-syntax-highlighting' \
    @zdharma-continuum/fast-syntax-highlighting \
  id-as'zsh-autosuggestions' \
    atload'_zsh_autosuggest_start' \
    @zsh-users/zsh-autosuggestions

if (( $+commands[nvim] )); then
  export EDITOR="nvim"
  export VISUAL="$EDITOR"
  alias v="$EDITOR"
fi

if (( $+commands[htop] )); then
  alias h=htop
fi

if (( $+commands[kubectl] )); then
  if (( $+commands[kubecolor] )); then
    alias kubectl=kubecolor
  fi
  alias k=kubectl
fi

if (( $+commands[lsd] )); then
  alias ls="lsd --size=short"
  alias lt="ls --tree"
fi

if (( $+commands[bat] )); then
  alias cat="bat --decorations never --paging never"
fi

if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
  export FZF_ALT_C_COMMAND="fd --type=d --hidden --exclude .git"
fi

if (( $+commands[zoxide] )); then
  alias cd=z
fi

# Disable highlighting of text pasted into the command line
zle_highlight=('paste:none')

# https://wiki.archlinux.org/index.php/zsh#Persistent_rehash
zstyle ':completion:*' rehash true

setopt interactive_comments

# Update everything, then prune dead completion symlinks + rebuild the dump
zup() {
  zinit update --all "$@"
  zinit cclear            # remove stray/broken completion symlinks
  rm -f ~/.zcompdump*     # force compinit to rebuild on reload
  exec zsh                # clean fpath + fresh dump in one shot
}