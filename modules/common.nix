{ config, pkgs, ... }:

{



boot = {
	kernelPackages = pkgs.linuxPackages_latest;
	
	loader = {
	timeout = 15;
	};

	systemd-boot = {
	enable = false;
	};

	efi.canTouchEfiVariables = true;

	grub = {
	enable = true;
	device = "nodev";
	efiSupport = true;
	useOSProber = true;
	};

	};

networking = {
	hostName = "PC";
	
	networkmanager = {
	enable = true;
	};




	};

time.timeZone = "Europe/Istanbul";

il8n.defaultLocale = "en_US.UTF-8";

console = {
	keyMap = "trq";
	font = "Lat2-Terminus16";
	};


services = {
	tailscale = {
	enable = true;
	};
	};
	openshh = {
	enable = true;
	};





nix.settings.experimental-features = ["nix-command" "flakes"];





enviroment.systemPackages = with pkgs; [
  alenjandra
  git
  neovim

];





}
