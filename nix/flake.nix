{
	outputs = { ... }@inputs:
		let
			lib = inputs.nixpkgs.lib;
			nix-darwin = inputs.nix-darwin;
			pkgs = import inputs.nixpkgs { system = systemSettings.system; };
			pkgs-stable = import inputs.nixpkgs-stable { system = systemSettings.system; };
			systemSettings = {
				system = "aarch64-darwin"; # [ x86_64-linux | aarch64-darwin ]
				hostname = "Tetromega";
				profile = "personal"; # [ minimal | personal]
				timezone = "America/Phoenix";
				locale = "en_US.UTF-8";
				gpuType = "nvidia"; # [ nvidia | none ]
			};

			userSettings = {
				username = "dallen";
				description = "Dallen Bryce";
				email = "dallenbryce4@outlook.com";
				wallpaper = ./assets/nixos-wallpaper-cool.png;
				clock24h = false;
			};

			themeSettings = import ./theme.nix {
				themeName = "cozy"; # [ cozy | cyberpunk ]
			};

		in {
			darwinConfigurations = {
				Tetramini = nix-darwin.lib.darwinSystem {
					system = systemSettings.system;
					specialArgs = {
						inherit inputs;
						inherit userSettings;
					};
					modules = [
						./systems/Tetramini.nix
						inputs.home-manager.darwinModules.home-manager {
							home-manager = {
								useGlobalPkgs = true;		
								useUserPackages = true;
								users.${userSettings.username} = {
									imports = [
									];
									home = {
										homeDirectory = "/Users/${userSettings.username}";
										stateVersion = "24.05";
									};
								};
							};
						}
					];
				};
			};

			nixosConfigurations = {
				Tetromega = lib.nixosSystem {
					system = systemSettings.system;
					specialArgs = { 
						inherit inputs;
						inherit pkgs-stable;
						inherit systemSettings;
						inherit userSettings;
						inherit themeSettings;
					};
					modules = [
						./configuration.nix
						inputs.nixvim.nixosModules.nixvim
						inputs.stylix.nixosModules.stylix
						inputs.home-manager.nixosModules.home-manager {
							home-manager = {
								useGlobalPkgs = true;
								useUserPackages = true;
								extraSpecialArgs = { 
									inherit inputs;
									inherit systemSettings;
									inherit userSettings;
									inherit themeSettings;
								};
								users.${userSettings.username} = {
									imports = [ 
										./home.nix
									];
								};
							};
						}
					];
				};
			};

		};

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
		nixpkgs-stable.url = "nixpkgs/nixos-24.05";
		nixpkgs-kernel.url = "github:nixos/nixpkgs/785feb91183a50959823ff9ba9ef673105259cd5";
		nix-darwin.url = "github:LnL7/nix-darwin/master";
		nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
		hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
		chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
		nixvim = {
			url = "github:nix-community/nixvim";
			# inputs.nixpkgs.follows = "nixpkgs";
		};
		blender-bin.url = "github:edolstra/nix-warez?dir=blender";
		home-manager = {
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		spicetify-nix = {
			url = "github:Gerg-L/spicetify-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		# zen-browser.url = "github:DallenB4/zen-browser-flake";
		# zen-browser.url = "git+file:///home/dallen/Projects/zen-browser-flake";
		stylix.url = "github:danth/stylix";
	};
}
