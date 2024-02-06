{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.tailscale-systray;

in {
  meta.maintainers = [ hm.maintainers.fabianhauser ];

  options = {
    services.tailscale-systray = {
      enable = mkEnableOption "Tailscale system tray";

      extraOptions = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Extra command-line arguments to pass to {command}`tailscale-systray`.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (hm.assertions.assertPlatform "services.tailscale-systray" pkgs
        platforms.linux)
    ];

    systemd.user.services.tailscale-systray = {
      Unit = {
        Description = "Tailscale system tray";
        Requires = [ "tray.target" ];
        After = [ "graphical-session-pre.target" "tray.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        ExecStart = escapeShellArgs
          ([ "${pkgs.tailscale-systray}/bin/tailscale-systray" ]
            ++ cfg.extraOptions);
      };
    };
  };
}
