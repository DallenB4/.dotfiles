{ config, lib, pkgs, pkgs-stable, inputs, systemSettings, userSettings, ... }:
let
  kernelPkgs = import inputs.nixpkgs-kernel { 
    system = systemSettings.system;
    config.allowUnfree = true;
  };
in
{
  imports = [ 
    (if systemSettings.profile == "personal" then ./profiles/personal.nix else null)
    ./hardware-configuration.nix
    ./modules/kanata
    ./modules/nixvim
    ./modules/zsh
  ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.warn-dirty = false;
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  hardware.graphics.enable = true;
  hardware.i2c.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.nvidia = lib.mkIf (systemSettings.gpuType == "nvidia") {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  boot = {
    kernelPackages = kernelPkgs.linuxPackages_6_10;
    supportedFilesystems = [
      "ntfs"
    ];
    kernelParams = [ (if systemSettings.gpuType == "nvidia" then "nvidia-drm.fbdev=1" else null) ];
    loader = {
      # systemd-boot.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 50;
      };
      timeout = 4;
    };
  };

  stylix = {
    enable = true;
    base16Scheme = ./styles/mytheme.yaml;
    image = userSettings.wallpaper;
    polarity = "dark";
    cursor.package = pkgs.apple-cursor;
    cursor.size = 22;
    cursor.name = "macOS-Monterey";
    # opacity.applications = 0.8;
    # opacity.terminal = 0.8;
    # opacity.desktop = 0.8;
    # opacity.popups = 0.8;
    targets.grub.enable = false;
    targets.gtk.enable = false;
    targets.nixvim.enable = false;
  };

  networking.hostName = systemSettings.hostname;
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Phoenix";
  time.hardwareClockInLocalTime = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    # useXkbConfig = true; # use xkb.options in tty.
  };

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${systemSettings.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${systemSettings.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };
    thunar.enable = true; 
    thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
    neovim.defaultEditor = true;
    gnome-disks.enable = true;
    hyprlock = {
      enable = true;
      package = pkgs.hyprlock.overrideAttrs (final: old: {
        patchPhase = ''
          substituteInPlace src/core/hyprlock.cpp \
          --replace "5000" "5"
        '';
      });
    };
  };

  services = {
    devmon.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    xserver.videoDrivers = [ (if systemSettings.gpuType == "nvidia" then "nvidia" else null) ];
    displayManager.autoLogin.user = userSettings.username;
    displayManager.sddm = {
      package = lib.mkForce pkgs.kdePackages.sddm;
      extraPackages = lib.mkForce [ pkgs.kdePackages.qt5compat ];
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
      wayland.compositor = "kwin";
      theme = "where_is_my_sddm_theme";
    };
    hypridle.enable = true;

    openssh.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      jack.enable = true;
      # extraConfig.pipewire."virtual-sink" = {
      #   "context.objects" = [
      #     {
      #       factory = "adapter";
      #       args = {
      #         "factory.name"            = "support.null-audio-sink";
      #         "node.name"               = "Main-Output-Proxy";
      #         "node.description"        = "Main Output";
      #         "media.class"             = "Audio/Sink";
      #         "audio.position"          = "FL,FR";
      #         "monitor.channel-volumes" = true;
      #         "monitor.passthrough"     = true;
      #       };
      #     }
      #   ];
      # };
    };

    printing = {
      enable = true;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { 
        fonts = [ 
          "JetBrainsMono"
        ];
      })
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono-Regular" ];
      };
    };
  };

  security.sudo.wheelNeedsPassword = false;
  security.pam.services.hyprlock = {};
  security.polkit.enable = true;

  users.users.${userSettings.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "asd";
    description = userSettings.description;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    alacritty
    android-tools
    blueman
    cava
    dunst
    ffmpeg
    firefox
    gimp
    git
    grim
    home-manager
    hyprpaper
    inputs.zen-browser.packages.${systemSettings.system}.default
    jq
    kdePackages.ark
    kdePackages.qtwayland
    libnotify
    libsForQt5.qt5.qtgraphicaleffects
    neofetch
    networkmanagerapplet
    pavucontrol
    playerctl
    python3Full
    qpwgraph
    qt5.qtwayland
    qt6.qtwayland
    slurp
    unzip
    vlc
    wl-clipboard
    (where-is-my-sddm-theme.override {
      themeConfig.General = with config.lib.stylix.colors; {
        passwordcharacter="∗";
        showUsersByDefault = true;
        background = toString ./assets/carbon.jpg;
        backgroundMode = "fill";
        passwordCursorColor = "#" + base0B;
        passwordInputBackground = "#60444444";
        passwordInputRadius = 8;
      };
    })
    xdg-user-dirs
  ];

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
      };
    };
  };

  environment.sessionVariables = {
    # NIXOS_OZONE_WL = 1;
    # QT_SCREEN_SCALE_FACTORS = "1.25";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [

  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05"; # Don't change! 
}

