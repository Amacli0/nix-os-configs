{ config, lib, pkgs, ... }:
{
  # Netdata - Sistem monitoring (hafif ve güzel)
  services.netdata = {
    enable = true;
    
    config = {
      global = {
        "default port" = "19999";
        "bind to" = "127.0.0.1";
      };
      
      web = {
        "allow connections from" = "localhost 127.0.0.1";
      };
    };
  };

  # Grafana (opsiyonel - resource intensive)
  # services.grafana = {
  #   enable = true;
  #   settings = {
  #     server = {
  #       http_addr = "127.0.0.1";
  #       http_port = 3002;
  #       domain = "metrics.deepshell.org";
  #       root_url = "https://metrics.deepshell.org";
  #     };
  #     
  #     database = {
  #       type = "postgres";
  #       host = "/run/postgresql";
  #       name = "grafana";
  #       user = "grafana";
  #     };
  #   };
  # };

  # Prometheus (opsiyonel - Grafana için veri kaynağı)
  # services.prometheus = {
  #   enable = true;
  #   port = 9090;
  #   
  #   exporters = {
  #     node = {
  #       enable = true;
  #       enabledCollectors = [ "systemd" ];
  #       port = 9100;
  #     };
  #     
  #     postgres = {
  #       enable = true;
  #       port = 9187;
  #       dataSourceName = "user=prometheus host=/run/postgresql sslmode=disable";
  #     };
  #   };
  #   
  #   scrapeConfigs = [
  #     {
  #       job_name = "node";
  #       static_configs = [{
  #         targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
  #       }];
  #     }
  #     {
  #       job_name = "postgres";
  #       static_configs = [{
  #         targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.postgres.port}" ];
  #       }];
  #     }
  #   ];
  # };
}
