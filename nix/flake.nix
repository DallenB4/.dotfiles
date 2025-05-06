{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nix-darwin, ... }@inputs: {

		darwinConfigurations."Tetramini" = nix-darwin.lib.darwinSystem {
			modules = [ ./configuration.nix ];
			specialArgs = { inherit inputs; };
		};

  };
}
