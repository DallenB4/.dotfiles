{ inputs, pkgs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};

  hazyThemeSrc = pkgs.fetchgit {
    url = "https://github.com/Astromations/Hazy";
    rev = "2fe1599e18cd0bfac02f8a846772574f5059715b";
    fetchSubmodules = false;
    deepClone = false;
    leaveDotGit = false;
    sha256 = "sha256-OAdBVIgtmMvUm66FI+Ls0YobkPVg67W3Up+AIFr5rhw=";
  };

  hazyTheme = {
    name = "Hazy";
    src = hazyThemeSrc;
    appendName = false;
    requiredExtensions = [
      {
        name = "hazy.js";
        src = hazyThemeSrc;
        filename = "hazy.js";
      }
    ];
    injectCss = true;
    overwriteAssets = false;
    replaceColors = true;
  };

  tokyoNightThemeSrc = pkgs.fetchgit {
    url = "https://github.com/evening-hs/Spotify-Tokyo-Night-Theme";
    rev = "d88ca06eaeeb424d19e0d6f7f8e614e4bce962be";
    fetchSubmodules = false;
    deepClone = false;
    leaveDotGit = false;
    sha256 = "sha256-cLj9v8qtHsdV9FfzV2Qf4pWO8AOBXu51U/lUMvdEXAk=";
  };

  tokyoNightTheme = {
    name = "Tokyo-Night";
    src = tokyoNightThemeSrc;
    appendName = false;
    injectCss = true;
    overwriteAssets = false;
    replaceColors = true;
  };

in
{
  imports = [
      inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify = {
    enable = true;
    theme = tokyoNightTheme;
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle
    ];
  };
}
