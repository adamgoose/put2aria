{
  inputs,
  cell,
}: {
  default = {
    lib,
    config,
    ...
  }: let
    cfg = config.services.put2aria;
    l = lib // builtins;
  in {
    options.services.put2aria = {
      enable = l.mkEnableOption (l.mdDoc "put2aria Server");

      user = l.mkOption {
        type = l.types.str;
        description = "User to run the HLSDL Server as";
      };

      listen = l.mkOption {
        type = l.types.str;
        default = ":8881";
        description = "Listen address for the HTTP Server";
      };

      putio = {
        oauthTokenFile = l.mkOption {
          type = l.types.str;
          description = "Path to file containing Put.io OAuth Token";
        };
      };

      aria2 = {
        rpcUrl = l.mkOption {
          type = l.types.str;
          description = "Aria2 WebSocket RPC URL";
        };

        rpcSecretFile = l.mkOption {
          type = l.types.str;
          description = "Path to file containing Aria2 RPC Secret";
        };
      };
    };

    config = l.mkIf cfg.enable {
      systemd.packages = [
        cell.apps.default
      ];

      environment.systemPackages = [
        cell.apps.default
      ];

      # Run the put2aria server
      systemd.services.put2aria = {
        description = "put2aria Server";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];

        environment = {
          PUT2ARIA_PUTIO_OAUTH_TOKEN_FILE = cfg.putio.oauthTokenFile;
          PUT2ARIA_ARIA2_RPC_URL = cfg.aria2.rpcUrl;
          PUT2ARIA_ARIA2_RPC_SECRET_FILE = cfg.aria2.rpcSecretFile;
          PUT2ARIA_LISTEN = cfg.listen;
        };

        serviceConfig = {
          Restart = "on-failure";
          SuccessExitStatus = "3 4";
          RestartForceExitStatus = "3 4";
          User = cfg.user;
          ExecStart = "${cell.apps.default}/bin/put2aria";
        };
      };
    };
  };
}
