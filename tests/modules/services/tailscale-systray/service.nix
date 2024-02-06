{ ... }:

{
  services.tailscale-systray = {
    enable = true;
    extraOptions = [ "-g" ];
  };

  test.stubs = { tailscale-systray = { }; };

  nmt.script = ''
    serviceFile=$(normalizeStorePaths home-files/.config/systemd/user/tailscale-systray.service)
    assertFileContent "$serviceFile" ${./expected.service}
  '';
}
