{ pkgs, ... }:

let

  davinci = import ./davinci-resolve-studio-19.nix;
    
  davinci-override = davinci {
    inherit (pkgs) stdenv lib cacert curl perl qt5 runCommandLocal unzip appimage-run
                    addDriverRunpath dbus libGLU xorg buildFHSEnv buildFHSEnvChroot
                    bash writeText ocl-icd xkeyboard_config glib libarchive libxcrypt
                    python3 aprutil makeDesktopItem copyDesktopItems jq common-updater-scripts
                    writeShellApplication;

  };
in {
  environment.systemPackages = [
    davinci-override
  ];
}
