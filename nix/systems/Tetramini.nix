{inputs, userSettings, ...}:
let

in {
	users.users.${userSettings.username} = {
		name = userSettings.username;
		home = "/Users/${userSettings.username}";
	};

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.warn-dirty = false;
  };

	system.stateVersion = 6;
}
