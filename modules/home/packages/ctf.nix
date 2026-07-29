{pkgs, ...}: {
  home.packages = with pkgs; [
    openvpn
    nmap
    gobuster
    netcat
    exploitdb
  ];
}
