{ inputs, config, pkgs, lib, ...}:

{
  environment.systemPackages = [
    pkgs.oh-my-posh
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {};
    autosuggestions.enable = true;
    syntaxHighlighting = {
      enable = true;
      styles = {};
    };
    promptInit = ''
      export LS_COLORS='*.nix=34'

      setopt hist_ignore_all_dups
      setopt hist_find_no_dups
      setopt appendhistory
      setopt sharehistory
      setopt hist_ignore_space

      HISTSIZE=9999
      SAVEHIST=$HISTSIZE
      HISTDUP=erase

      bindkey -e
      bindkey ';5A' history-search-backward
      bindkey ';5B' history-search-forward
      bindkey ";5C" forward-word
      bindkey ";3C" forward-word
      bindkey ";5D" backward-word
      bindkey ";3D" backward-word
      bindkey "^[[3~" delete-char
      bindkey "^H" backward-delete-word
      bindkey "^[[3;5~" delete-word

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"

      unset autocd nomatch
      eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ${./config.toml})"
    '';
  };

  users.defaultUserShell = pkgs.zsh;
}
