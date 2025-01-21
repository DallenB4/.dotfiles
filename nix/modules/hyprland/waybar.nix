{ config, hyprSettings, userSettings, lib }:

let
  inherit (userSettings) clock24h;
  font = "JetBrainsMono Nerd Font Mono";
  colors = config.lib.stylix.colors;
  background = colors.base01;
  borderRadius = builtins.toString (hyprSettings.rounding + hyprSettings.border_size * 2);
  borderWidth = builtins.toString (hyprSettings.border_size * 2);
  gaps_out = builtins.toString hyprSettings.gaps_out;
  borderStyle = "inset 0 0 0 ${borderWidth}px lighter(#${background})";
in
{
  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        spacing = hyprSettings.gaps_out;
        margin-top = hyprSettings.gaps_out;
        margin-bottom = hyprSettings.gaps_in / 2;

        output = "DP-1";

        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
          "cpu"
          "memory"
          "disk"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "group/tray-group"
          "network"
          "bluetooth"
          "wireplumber"
        ];

        "custom/launcher" = {
          tooltip = false;
          format = "󱄅";
          on-click = "sleep 0.1 && rofi -show drun";
          on-click-right = "hyprctl dispatch togglespecialworkspace magic";
        };

        "hyprland/window" = {
          max-length = 22;
          rewrite = {
            "" = "~";
          };
        };
        
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            default = "◆";
            active = "●";
          };

          persistent-workspaces = {
           "1" = [];
		       "2" = [];
		       "3" = [];
		       "4" = [];
	        };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        "memory" = {
          interval = 15;
          format = "<span font='1.4em'></span> {}%";
        };

        "cpu" = {
          interval = 5;
          format = "<span font='1.4em'></span> {usage}%";
        };

        "disk" = {
          format = "<span font='1.25em'></span> {percentage_used}%";
          tooltip-format = "{used} used out of {total} ({free} free)";
        };

        "group/tray-group" = {
          orientation = "horizontal";
          modules = [
            "custom/tray-icon"
            "tray"
          ];
          drawer = {
            transition-duration = 400;
            click-to-reveal = true;
            transition-left-to-right = false;
          };
        };

        "custom/tray-icon" = {
          tooltip = false;  
          format = "󱗼";
        };

        "tray" = {
          spacing = 12;
        };

        "group/connections" = {
          modules = [
            "network"
            "bluetooth"
          ];
        };

        "network" = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-ethernet = "󰌗";
          format-wifi = "<span font='1.5em'>{icon}</span> {signalStrength}%";
          format-disconnected = "󰇨";
          tooltip-format-wifi = "┌[{essid}]\n├──({ipaddr})\n└──({bandwidthUpBytes}󰁜 {bandwidthDownBytes}󰁂)";
          tooltip-format-ethernet = "┌[Ethernet]\n├──({ipaddr})\n└──({bandwidthUpBytes}󰁜 {bandwidthDownBytes}󰁂)";
          tooltip-format-disconnected = "[Network Disconnected]";
          on-click = "hyprctl dispatch exec [float] nm-connection-editor";
        };

        "bluetooth" = {
          format-on = "󰂯";
          format-off = "󰂲";
          format-connected = "<span font='1.51em'>󰂱</span>";
          on-click = "hyprctl dispatch exec [float] blueman-manager";
          tooltip-format-on = "[Bluetooth]-({num_connections})";
          tooltip-format-off = "[Bluetooth Disabled]";
          tooltip-format-connected = "┌[Bluetooth]-({num_connections})\n{device_enumerate}";
          tooltip-format-enumerate-connected = "├──({device_alias})";
        };

        "wireplumber" = {
          format = "<span font='1.51em'></span>  {volume}%";
          format-muted = "<span font='1.51em'></span>  {volume}%";
          scroll-step = 2.0;
          on-click-right = "hyprctl dispatch exec \"[float;size 50%]\" pavucontrol";
          on-click-middle = "wpctl set-mute @DEFAULT_SINK@ toggle";
          tooltip = false;
        };

        "clock" = {
          format = if clock24h == true then ''{:L%H ❖ %M}'' else ''{:L%I ❖ %M}'';
          timezone = "America/Phoenix";
          tooltip = true;
          tooltip-format = "<big>{:%A, %B %d, %Y }</big>\n<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos= "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
           on-click-right = "mode";
           on-click-forward = "tz_up";
           on-click-backward = "tz_down";
           };
        };

      }
    ];
    style = /* CSS */ ''
      * {

      }
      window#waybar {
        background: rgba(0,0,0,0);
      }
      tooltip label {
        font-family: ${font};
        color: #${colors.base05};
      }
      #custom-launcher {
        color: #${colors.base08};
        background: #${colors.base01};
        padding: 2px 1em 0 0.5em;
        font-size: 1.5em;

        border-radius: 0 ${borderRadius}px ${borderRadius}px 0;
        box-shadow: ${borderStyle};
      }
      #workspaces {
        background: #${colors.base01};
        padding: 6px;
        font-weight: bold;

        border-radius: ${borderRadius}px;
        box-shadow: ${borderStyle};
      }
      #workspaces button {
        padding: 0 0.5em;
        margin: 0 0.25em;
        border-radius: ${borderRadius}px;
        color: darker(#${colors.base05});
      }
      #workspaces button.empty {
        color: #${colors.base02};
      }
      #workspaces button.active {
        color: #${colors.base09};
      }
      #cpu, #memory, #disk {
        font-family: ${font};
        color: #${colors.base0A};
        background: #${colors.base01};
        font-weight: bold;

        box-shadow: ${borderStyle};
      }
      #cpu {
        border-radius: ${borderRadius}px 0 0 ${borderRadius}px;
        padding: 2px 12px 2px 16px;
      }
      #memory {
        padding: 2px 12px;
      }
      #disk {
        border-radius: 0 ${borderRadius}px ${borderRadius}px 0;
        padding: 2px 16px 2px 12px;
      }
      #window {
        font-family: ${font};
        color: #${colors.base0B};
        background: #${colors.base01};
        padding: 2px 16px;
        font-weight: bold;

        border-radius: ${borderRadius}px;
        box-shadow: ${borderStyle};
      }
      #clock {
        color: #${colors.base05};
        background: #${colors.base01};
        padding: 4px 16px;
        font-weight: bold;
        font-size: 1.25rem;

        border-radius: ${borderRadius}px;
        box-shadow: ${borderStyle};
      }
      #tray-group {
        padding: 0 0 0 8px;
        background: #${colors.base01};
        border-radius: ${borderRadius}px;
        box-shadow: ${borderStyle};
      }
      #custom-tray-icon {
        color: #${colors.base0C};
        margin: 0 16px 0 8;
      }
      #tray {
        margin: 0 8px 0 8;
      }
      #network, #bluetooth {
        color: #${colors.base0D};
        font-family: ${font};
        font-weight: bold;
        background: #${colors.base01};

        box-shadow: ${borderStyle};
      }
      #network {
        border-radius: ${borderRadius}px 0 0 ${borderRadius}px;
        padding: 2px 12px 2px 16px;
      }
      #bluetooth {
        border-radius: 0 ${borderRadius}px ${borderRadius}px 0;
        padding: 2px 16px 2px 12px;
      }
      #wireplumber {
        font-family: ${font};
        color: #${colors.base0E};
        background: #${colors.base01};
        padding: 2px 16px;
        font-weight: bold;

        border-radius: ${borderRadius}px;
        box-shadow: ${borderStyle};
      }
    '';
  };
}
