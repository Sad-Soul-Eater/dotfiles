#!/usr/bin/env zsh

ZINIT_HOME="${HOME}/.zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone --depth 1 --single-branch 'https://github.com/zdharma-continuum/zinit.git' "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# PATHs
for path_dir in "$HOME/.krew/bin" "$HOME/.cargo/bin" "$HOME/.local/bin" "$HOME/go/bin"; do
  if [[ -d "$path_dir" ]]; then
    PATH="$PATH:$path_dir"
  fi
done

# Prompt
zinit ice id-as'powerlevel10k-generated.zsh' link light
if [[ -f "$HOME/.zsh/powerlevel10k-generated.zsh" ]]; then
  zinit snippet "$HOME/.zsh/powerlevel10k-generated.zsh"
else
  zinit snippet 'https://github.com/Sad-Soul-Eater/dotfiles/raw/master/.zsh/powerlevel10k-generated.zsh'
fi

zinit ice id-as'powerlevel10k-settings.zsh' link light
if [[ -f "$HOME/.zsh/powerlevel10k-settings.zsh" ]]; then
  zinit snippet "$HOME/.zsh/powerlevel10k-settings.zsh"
else
  zinit snippet 'https://github.com/Sad-Soul-Eater/dotfiles/raw/master/.zsh/powerlevel10k-settings.zsh'
fi

zinit depth'1' nocd light-mode for \
  id-as'powerlevel10k' \
    @romkatv/powerlevel10k

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
  id-as'cht.sh' \
    run-atpull \
    atclone'curl -sL https://cht.sh/:cht.sh > cht.sh; curl -sL https://cheat.sh/:zsh > _cht.sh' \
    atpull'%atclone' \
    pick'cht.sh' \
    @zdharma-continuum/null \
  id-as'zoxide' \
    from'gh-r' \
    atclone'./zoxide init zsh > init.zsh && zcompile init.zsh' \
    atpull'%atclone' \
    src'init.zsh' \
    atload'alias cd=z' \
    @ajeetdsouza/zoxide \
  id-as'f2' \
    from'gh-r' \
    cp'scripts/completions/f2.zsh -> _f2' \
    pick'f2' \
    @ayoisaiah/f2

# Programs that will not work in Termux
zinit as'program' depth'1' lucid light-mode if'[[ -z "$TERMUX_VERSION" ]]' for \
  id-as'lsd' \
    from'gh-r' \
    mv'lsd*/lsd -> lsd' \
    atclone'mv lsd*/*/_lsd .' \
    atpull'%atclone' \
    @lsd-rs/lsd \
  id-as'atuin' \
    from'gh-r' \
    bpick'*.tar.gz' \
    mv'atuin*/atuin -> atuin' \
    atclone'./atuin gen-completions --shell zsh > _atuin' \
    atpull'%atclone' \
    @atuinsh/atuin \
  id-as'direnv' \
    from'gh-r' \
    mv'direnv* -> direnv' \
    @direnv/direnv \
  id-as'bat' \
    from'gh-r' \
    mv'bat*/bat -> bat' \
    cp'bat*/autocomplete/bat.zsh -> _bat' \
    @sharkdp/bat \
  id-as'fd' \
    from'gh-r' \
    mv'fd*/fd -> fd' \
    atclone'mv fd*/*/_fd .' \
    atpull'%atclone' \
    @sharkdp/fd \
  id-as'delta' \
    from'gh-r' \
    mv'delta*/delta -> delta' \
    @dandavison/delta \
  id-as'ripgrep' \
    from'gh-r' \
    mv'ripgrep*/rg -> rg' \
    atclone'mv ripgrep*/*/_rg .' \
    atpull'%atclone' \
    @BurntSushi/ripgrep \
  id-as'dust' \
    from'gh-r' \
    mv'dust*/dust -> dust' \
    @bootandy/dust \
  id-as'sd' \
    from'gh-r' \
    mv'sd*/sd -> sd' \
    atclone'mv sd*/*/_sd .' \
    atpull'%atclone' \
    @chmln/sd \
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
    @bitnami-labs/sealed-secrets \
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
    atclone'./talosctl completion zsh > _talosctl' \
    atpull'%atclone' \
    @siderolabs/talos

# Programs init
zinit as'program' wait'0a' depth'1' lucid light-mode for \
  id-as'lsd-init' \
    has'lsd' \
    atload'alias ls="lsd --size=short"; alias lt="ls --tree"' \
    @zdharma-continuum/null \
  id-as'atuin-init' \
    has'atuin' \
    atload'eval "$(atuin init zsh)"' \
    @zdharma-continuum/null \
  id-as'direnv-init' \
    has'direnv' \
    atload'eval "$(direnv hook zsh)"' \
    @zdharma-continuum/null \
  id-as'bat-init' \
    has'bat' \
    atload'alias cat="bat --decorations never --paging never"' \
    @zdharma-continuum/null \
  id-as'kubecolor-init' \
    has'kubecolor' \
    atload'alias kubectl="kubecolor"' \
    @zdharma-continuum/null

# Oh My Zsh plugins
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
zinit wait'0b' lucid light-mode for \
  OMZP::colored-man-pages \
  OMZP::extract \
  OMZP::git \
  OMZP::sudo \
  OMZP::systemd

# Completions
zinit as'completion' depth'1' wait'0b' lucid blockf nocompile atpull'zinit creinstall -q .' light-mode for \
  zsh-users/zsh-completions \
  zchee/zsh-completions

# Plugins
zinit depth'1' wait'0b' lucid blockf light-mode for \
  id-as'history-search-multi-word' \
    if'[[ -z "$commands[atuin]" ]]' \
    @zdharma-continuum/history-search-multi-word \
  id-as'fzf-tab' \
    Aloxaf/fzf-tab \
  id-as'forgit' \
    wfxr/forgit \
  id-as'zsh-you-should-use' \
    MichaelAquilina/zsh-you-should-use

zinit depth'1' wait'0c' lucid light-mode for \
  id-as'fast-syntax-highlighting' \
    atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  id-as'zsh-autosuggestions' \
    atinit'ZINIT[COMPINIT_OPTS]=-u' \
    atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(reset-prompt); _zsh_autosuggest_start' \
    zsh-users/zsh-autosuggestions

if (( $+commands[nvim] )); then
  export EDITOR="nvim"
  alias v="nvim"
fi

if (( $+commands[htop] )); then
  alias h=htop
fi

if (( $+commands[kubectl] )); then
  alias k=kubectl
fi

if (( $+commands[paru] )); then
  alias puconf='paru -Pg'
  alias puupg='paru -Syu'
  alias pusu='paru -Syu --noconfirm'
  alias puin='paru -S'
  alias puins='paru -U'
  alias pure='paru -R'
  alias purem='paru -Rns'
  alias purep='paru -Si'
  alias pureps='paru -Ss'
  alias puloc='paru -Qi'
  alias pulocs='paru -Qs'
  alias pulst='paru -Qe'
  alias puorph='paru -Qtd'
  alias puinsd='paru -S --asdeps'
  alias pumir='paru -Syy'
  alias puupd='paru -Sy'
fi

# Disable highlighting of text pasted into the command line
zle_highlight=('paste:none')

# https://wiki.archlinux.org/index.php/zsh#Persistent_rehash
zstyle ':completion:*' rehash true
