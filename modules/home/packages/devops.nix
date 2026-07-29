{pkgs, ...}: {
  home.packages = with pkgs; [
    opentofu
    terraform
    awscli2
    docker
    docker-compose
    distrobox
    ansible
    # kubectl
    talosctl
    kubernetes-helm
    minikube
  ];
}
