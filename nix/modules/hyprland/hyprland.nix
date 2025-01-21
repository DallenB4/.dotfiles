{ inputs, config, hyprSettings, systemSettings, userSettings, lib }:

let
  colors = config.lib.stylix.colors;
  rgb = color: "rgb(${color})";
  rgba = color: "rgba(${color}ff)";
in
{
  programs.hyprlock.enable = true;
  programs.hyprlock.settings = {
    general = {
      ignore_empty_input = true;
      disable_loading_bar = true;
      immediate_render = true;
      no_fade_out = true;
      no_fade_in = true;
    };
    
    background = [
      {
        path = "${userSettings.wallpaper}";
      }
    ];

    label = [
      {
        text = "$TIME";
        text_align = "center";
        font_size = 70;
        position = "0, 100";
      }
    ];
  
    input-field = [
      {
        size = "200, 50";
        position = "0, -80";
        monitor = "";
        dots_center = true;
        fade_on_empty = false;
        font_color = "rgb(202, 211, 245)";
        inner_color = rgb colors.base00;
        outer_color = rgb colors.base0D;
        outline_thickness = 2;
        shadow_passes = 2;
      }
    ];
  };

  services.hypridle.enable = true;
  services.hypridle.settings = {
    general = {
      lock_cmd = "pidof hyprlock || hyprlock";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on";
    };
    listener = [
      {
        timeout = 1800;
        on-timeout = "sh ${../../scripts/screen_off.sh}";
        on-resume = "sh ${../../scripts/screen_on.sh}";
      }
    ];
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.package = inputs.hyprland.packages.${systemSettings.system}.hyprland;
  wayland.windowManager.hyprland.settings = {
    xwayland.force_zero_scaling = true;
    monitor = [
      "DP-1,2560x1440@179.95,0x0,1.25"
      "DP-2,1920x1200@59.95,-960x-5,1.25,transform,1"
      "DVI-I-1,1920x1200@59.95,2048x-5,1.25,transform,1"
    ];
    "$terminal" = "alacritty";
    "$browser" = "zen";
    
    "$fileManager" = "thunar";

    general = { 
      gaps_in = hyprSettings.gaps_in;
      gaps_out = hyprSettings.gaps_out;

      border_size = hyprSettings.border_size;

      resize_on_border = false;
      allow_tearing = false;
      layout = "dwindle";
    };

    exec-once = [
      "hyprctl dispatch -- exec [workspace special:magic silent] vesktop --start-minimized & sleep 5; hyprctl dispatch exec [workspace special:magic silent] vesktop"
      "sleep 6; hyprctl dispatch exec [workspace special:magic silent] spotify"
      "waybar"
      "playerctld"
      "qbwgraph -m -a"
      "sleep 4; sh ${../../scripts/asd.sh}"
    ];

    decoration = {
      rounding = hyprSettings.rounding;

      # Change transparency of focused and unfocused windows
      active_opacity = 1.0;
      inactive_opacity = 1.0;

      drop_shadow = true;
      shadow_range = 4;
      shadow_render_power = 3;

      blur = {
        enabled = true;
        size = 5;
        passes = 3;
        special = true;
      };
    };

    cursor = {
      default_monitor = "DP-1";
      # no_hardware_cursors = true;
      # no_break_fs_vrr = true;

      # OR
      
      # allow_dumb_copy = true;
    };

    animations = {
      enabled = true;      
      bezier = [
        "myBezier, 0.05, 0.9, 0.1, 1.05"
      ];

      animation = [
        "windows, 1, 4, myBezier, popin 80%"
        "windowsOut, 1, 4, default, popin 80%"
        "fade, 1, 4, default"
        "workspaces, 1, 4, default"
        "specialWorkspace, 1, 4, default, slidefadevert 50%"
      ];
    };

    dwindle = {
      pseudotile = true; # Master switch for pseudotiling. 
      preserve_split = true; # You probably want this
    };

    group = {
      "col.border_active" = lib.mkForce (rgb colors.base0B);
      groupbar = {
        enabled = false;
      };
    };

    misc = { 
      disable_hyprland_logo = true;
      middle_click_paste = false;
      disable_splash_rendering = true;
      animate_manual_resizes = true;
      # enable_swallow = true;
      # swallow_regex = "Alacritty";
    };

    render = {
      explicit_sync = 0;
      explicit_sync_kms = 0;
    };

    input = {
      kb_layout = "us";
      # kb_variant = null;
      # kb_model = null;
      # kb_options = null;
      # kb_rules = null;

      numlock_by_default = true;

      follow_mouse = -1;
      mouse_refocus = false;
      float_switch_override_focus = 0;

      sensitivity = -0.4; # -1.0 - 1.0, 0 means no modification.

      touchpad = {
        natural_scroll = false;
      };
    };

     # https://wiki.hyprland.org/Configuring/Variables/#gestures
    gestures = {
      workspace_swipe = true;
    };

    ####################
    ### KEYBINDINGSS ###
    ####################

    "$mainMod" = "SUPER"; 

    bind = [
      "$mainMod, Return, exec, $terminal"
      "$mainMod, Z, exec, $browser"
      "$mainMod, C, killactive"
      "$mainMod SHIFT, C, exec, hyprctl kill"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, F, togglefloating"
      "$mainMod, P, pseudo"
      "$mainMod SHIFT, P, pin"
      "$mainMod, T, swapsplit"
      "$mainMod, Y, togglesplit"
      "$mainMod, F11, fullscreen"
      "$mainMod SHIFT, F11, fullscreen, 1"
      "$mainMod CTRL, L, exec, ${../../scripts/lock.sh}"

      # Rofi
      "$mainMod, r, exec, rofi -show drun"
      "$mainMod SHIFT, r, exec, rofi -show run"
      "$mainMod, tab, exec, rofi -show window"
      "$mainMod, period, exec, rofi -show emoji"
      "$mainMod, comma, exec, rofi -show calc"

      # Screenshots
      "$mainMod SHIFT, P, exec, grim -c -o \"$(hyprctl activeworkspace -j | jq -r '.monitor')\" $(xdg-user-dir)/Pictures/$(date +'%s_screenshot.png')"
      "$mainMod SHIFT CTRL, P, exec, grim -g \"$(slurp)\" - | wl-copy"

      ", XF86HomePage, exec, zen"
      ", XF86Tools, exec, spotify"

      "$mainMod CTRL, j, changegroupactive, f"
      "$mainMod CTRL, k, changegroupactive, b"
      "$mainMod, g, togglegroup"

      "Alt_L $mainMod, h, movewindoworgroup, l"
      "Alt_L $mainMod, l, movewindoworgroup, r"
      "Alt_L $mainMod, k, movewindoworgroup, u"
      "Alt_L $mainMod, j, movewindoworgroup, d"

      "$mainMod, h, movefocus, l"
      "$mainMod, l, movefocus, r"
      "$mainMod, k, movefocus, u"
      "$mainMod, j, movefocus, d"

      "$mainMod, grave, workspace, 5"
      "$mainMod, 5, workspace, 6"
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"

      ", mouse:275, workspace, e-1"
      "Control_L $mainMod, left, workspace, e-1"
      ", mouse:276, workspace, e+1"
      "Control_L $mainMod, right, workspace, e+1"

      "$mainMod SHIFT, grave, movetoworkspace, 5"
      "$mainMod SHIFT, x, movetoworkspace, 6"
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"

      "$mainMod, S, focusmonitor, DP-1"
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"

      # Scroll through existing workspaces with mainMod + scroll
      "$mainMod, mouse_down, workspace, e+1"
      "$mainMod, mouse_up, workspace, e-1"
    ];

    binde = [
      "Shift_L $mainMod, h, resizeactive, -100 0"
      "Shift_L $mainMod, l, resizeactive, 100 0"
      "Shift_L $mainMod, k, resizeactive, 0 -100"
      "Shift_L $mainMod, j, resizeactive, 0 100"
    ];

    bindel = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
    ];

    bindl = [
      "SHIFT $mainMod, Escape, exit"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioNext, exec, playerctl next"
    ];
    
    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
      "$mainMod SHIFT, mouse:273, resizewindow 1"
    ];

    # Workspace Rules
    workspace = [
      "1, monitor:DP-1, default:true"
      "2, monitor:DP-1"
      "3, monitor:DP-1"
      "4, monitor:DP-1"
      "5, monitor:DP-2, default:true"
      "6, monitor:DVI-I-1, default:true"
      "special:magic, monitor:DP-1"
    ];

    # Window Rules
    windowrulev2 = [
      "workspace special:magic, noinitialfocus, class:vesktop"
      "workspace special:magic, class:Spotify"
      "rounding 0, focus:1"
      "suppressevent maximize, class:.*"
      "float, title:^(Console window for )(.*)$"
      "float, title:^(Open Files)$"
      "float, class:^(org.rncbc.qpwgraph)$"
      "tile, title:^(FL Studio 2024)$"
      "tile, class:^(Aseprite)$"
      "float, title:^(Fusion Reactor)$"
      "float, title:^(Picture-in-Picture)$"
      "keepaspectratio, title:^(Picture-in-Picture)$"
      "renderunfocused, class:^(resolve)$"
      "renderunfocused, class:^(com.obsproject.Studio)$"
    ];
  };
}
