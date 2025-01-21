{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = [ inputs.blender-bin.overlays.default ];
  environment.systemPackages = [ pkgs.blender_4_2 ];
}
