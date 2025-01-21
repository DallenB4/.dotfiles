{ pkgs, config, ... }:

{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-move-transition
      obs-vkcapture
    ];
  };
}
