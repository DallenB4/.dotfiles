{ themeName ? "cozy", ... }:

let
  themes = {
    cozy = {
      border_size = 2;
      rounding = 8;
      gaps_out = 4;
      gaps_in = 2;
    };
    cyberpunk = {
      border_size = 0;
      rounding = 0;
      gaps_out = 0;
      gaps_in = 0;
    };
  };

in {
  themeName = themeName;
  theme = themes.${themeName};
}
