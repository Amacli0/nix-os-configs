{
  config,
  pkgs,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      timeout = 15;

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };

      systemd-boot = {
        enable = false;
      };
    };
  };
  networking = {
    networkmanager = {
      enable = true;
    };
  };

  time.timeZone = "Europe/Istanbul";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    keyMap = "trq";
    font = "Lat2-Terminus16";
  };

  services = {
    tailscale = {
      enable = true;
    };

    openssh = {
      enable = true;
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    alejandra
    git
    neovim
    age
    sops
  ];


sops = {
    enable = true;
    age.keyFile = "/etc/sops/age/keys.txt";

defaultSopsFile = ./secrets/main.yaml;
    secrets.test_key = {
	key = "test_key";

	path = "/run/secrets/test_key";

	owner = "root";

	mode = "0444";

	};
	
};
systemd.services.sops-test-verification = {
    description = "SOPS Decryption Test Service";
    wantedBy = [ "multi-user.target" ];
    # Sırların (Secrets) dağıtılmasından sonra çalışır
    after = [ "sops-keys.service" ]; 
    serviceConfig = {
      Type = "oneshot";
      # Sırrın dosya yolunu bir ortam değişkeni olarak ayarla
      Environment = [ "SECRET_PATH=${config.sops.secrets.test_key.path}" ];
      # Gizli dosyanın içeriğini okur ve /tmp/sops_test_result.txt dosyasına yazar
      ExecStart = "${pkgs.coreutils}/bin/sh -c '${pkgs.coreutils}/bin/cat $SECRET_PATH > /tmp/sops_test_result.txt'";
    };
  };

}
