{ lib, pkgs, config, inputs, ... }:

{
  imports = [
    ./modules/hyprland
    ./modules/spotify
    ./modules/git
    ./modules/rofi
    # ./modules/syncthing
    ./modules/obs-studio
  ];

  home.packages = with pkgs;[
    cmatrix
    figlet
    gparted
  ];

  gtk = {
    enable = true;

    theme = {
      name = lib.mkForce "Tokyonight-Dark";
      package = lib.mkForce pkgs.tokyonight-gtk-theme;
    };

    iconTheme = {
      name = "Numix";
      package = pkgs.numix-icon-theme;
    };
  };

  stylix = {
    targets.waybar.enable = false;
    # targets.spicetify.enable = false;
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        corner_radius = 8;
      };
    };
  };

  xdg.enable = true;

  xsession.numlock.enable = true;

  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    env.TERM = "xterm-256color";
    window.padding = { x = 4; y = 4; } ;
  };

  programs.cava.enable = true;
  programs.cava.settings = {
    input.method = "pipewire";
    general.autosens = 1;
    smoothing = {
      monstercat = 1;
      noise_reduction = 64;
    };
    output.show_idle_bar_heads = 1;
  
    color = {
      gradient = 1;
      gradient_color_1 = "'#00FFAE'";
      gradient_color_2 = "'#07f8ba'";
      gradient_color_3 = "'#0ff0c5'";
      gradient_color_4 = "'#16e9d1'";
      gradient_color_5 = "'#1de2dc'";
      gradient_color_6 = "'#24dbe8'";
      gradient_color_7 = "'#2cd3f3'";
      gradient_color_8 = "'#33ccff')";
    };
  };
  
  home.stateVersion = "24.05";
}
