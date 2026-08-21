# Note to self, move per-app directories to their own module, so we only keep the needed directories.
# For example mullvad, micro, spotify, etc.

{ self, inputs, ... }: {
	flake.nixosModules.base = {
		imports = [
			inputs.preservation.nixosModules.default
		];

		systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
		
		preservation = {
			enable = true;
			preserveAt."/persistent" = {
				directories = [
					"/var/lib/bluetooth"
					"/etc/NetworkManager/system-connections"
					"/etc/mullvad-vpn"
					{ directory = "/var/lib/nixos"; inInitrd = true; }
				];
				
				files = [
					{ file = "/etc/machine-id"; inInitrd = true; }
				];

				users = {
					jorink = {
						directories = [
							"NixOS"
							"repos"
							"Downloads"
							"Documents"
							".ssh"
							".steam"
							".claude"
							".config/spotify"
							".config/ncspot"
							".config/wivrn"
							".config/librewolf"
							".config/micro"
							".config/Mullvad VPN"
							".local/state/noctalia"
							".local/state/wireplumber"
							".local/share/zsh"
							".local/share/Steam"
							".local/share/keyrings"
							".local/share/me.proton.authenticator"
						];
						files = [
							".claude.json"
						];
					};
					root = {
						home = "/root";
						directories = [
							".ssh"
						];
						files = [
							"example"
						];
					};
				};
			};
		};		
	};
}
