{ inputs, systemSettings, pkgs, ... }:

let

in
{
  imports = [
    ../modules/blender
    ../modules/davinci
    ../modules/fl-studio
    ../modules/godot
    # ../modules/syncthing
  ];

  environment.systemPackages = with pkgs; [
    krita
    vesktop 
    obsidian
    keepassxc
    prismlauncher 
    temurin-jre-bin-21
    jetbrains.idea-community-bin
    # glfw
    qbittorrent
    gpt4all-cuda
    aseprite
  ];

  # services.open-webui = {
  #   enable = true;
  #   port = 8081;
  #   host = "0.0.0.0";
  #   openFirewall = true;
  # };

  # services.sunshine = {
  #   enable = true;
  #   openFirewall = true;
  #   capSysAdmin = true;
  # };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 8081 25565 12135 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
}
