{ config, pkgs, userSettings, ... }:

{
  programs.git.enable = true;
  programs.git.userName = userSettings.description;
  programs.git.userEmail = userSettings.email;
}
