{ pkgs, config, themeSettings, ...}:
let
  colors = config.lib.stylix.colors;
  borderRadius = builtins.toString (themeSettings.theme.border_size + themeSettings.theme.border_size * 2);
  gaps_in = builtins.toString (themeSettings.theme.gaps_in);
in {
  config.programs.rofi = {
    package = pkgs.rofi-wayland;
    enable = true;
    plugins = with pkgs; [
      rofi-emoji-wayland
      (rofi-calc.override { rofi-unwrapped = rofi-wayland-unwrapped; })
    ];
    extraConfig = {
      modes = "drun,run,ssh,window,emoji,calc";
      show-icons = true;
      display-drun = "Run...";
      display-run = " ";
      display-window = " ";
      display-calc = " ";
      display-emoji = " ";
      display-ssh = "SSH";
      window-format = "{w} · {c} · {t}";
      parse-known-hosts = false;
    };
    theme = {
      mainbox = {
        spacing = "${gaps_in}px";
      };
      inputbar = {
        border-radius = "${borderRadius}px";
      };
      entry = {

      };
      listview = {
        border-radius = "${borderRadius}px";
      };
    };
  };
}
