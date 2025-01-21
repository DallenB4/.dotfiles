{ inputs, config, systemSettings, userSettings, themeSettings, lib, ... }:
let
  hyprSettings = rec {
    border_size = themeSettings.theme.border_size;
    rounding = themeSettings.theme.rounding;
    gaps_out = themeSettings.theme.gaps_out;
    gaps_in = themeSettings.theme.gaps_in;

    toString = {
      border_size = builtins.toString border_size;
      rounding = builtins.toString rounding;
      gaps_out = builtins.toString gaps_out;
      gaps_in = builtins.toString gaps_in;
    };
  };
in
{
  imports = [
    (import ./hyprland.nix { inherit inputs config hyprSettings systemSettings userSettings lib; })
    (import ./waybar.nix { inherit config hyprSettings userSettings lib; })
  ];
}
