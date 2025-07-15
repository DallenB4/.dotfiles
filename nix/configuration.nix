{ pkgs, inputs, ... }:

{
	system.stateVersion = 6;
	nixpkgs.hostPlatform = "aarch64-darwin";
	nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
	nix.settings.experimental-features = "nix-command flakes";

	environment.systemPackages = with pkgs; [
		neofetch
		nixd
		nixfmt-rfc-style
	];

	system.defaults = {
		NSGlobalDomain.AppleInterfaceStyle = "Dark";
	};
}
