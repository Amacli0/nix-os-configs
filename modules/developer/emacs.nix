{
  config,
  pkgs,
  ...
}: {
  services = {
    emacs = {
      enable = true;
      startWithGraphical = true;
    };
  };
}
