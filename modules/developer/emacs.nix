{
  config,
  pkgs,
  ...
}: {
  services.emacs = {
    enable = true;
    startWithGraphical = true;
  };

  services.xserver = {
    enable = true;
    windowManager.exwm = {
      enable = true;
    };
  };
}
