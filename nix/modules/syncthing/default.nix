{ config, pkgs, userSettings, ... }:

{ 
  # services.syncthing = {
  #   enable = false;
  #   user = userSettings.username;
  #   overrideFolders = false;
  #   overrideDevices = false;
  # };

  # environment.systemPackages = [ pkgs.syncthing ];

  services.syncthing.enable = true;
  services.syncthing.tray.enable = true;
}
