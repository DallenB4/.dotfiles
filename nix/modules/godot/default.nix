{ inputs, systemSettings, pkgs, ... }:
let
  chaotic = inputs.chaotic.packages.${systemSettings.system};
  chaotic-nixpkgs = inputs.chaotic.inputs.nixpkgs.legacyPackages.${systemSettings.system};
in
{
  environment.systemPackages = [
    (chaotic.godot_4-mono.overrideAttrs (old: {
      postInstall = ''
        wrapProgram $out/bin/godot4-mono \
          --set LD_LIBRARY_PATH "${pkgs.wayland}/lib" \
          --add-flags "--display-driver wayland"
      '';
    }))
    chaotic-nixpkgs.dotnet-sdk_8
    chaotic-nixpkgs.dotnet-runtime_8
    chaotic-nixpkgs.mono
    # pkgs.dotnet-sdk_8
    # pkgs.dotnet-runtime_8
  ];
}
