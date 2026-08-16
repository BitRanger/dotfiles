{
  bit.dev.ghostty = {
    homeManager = {
      programs.ghostty = {
        enable = true;
        enableFishIntegration = true;
        installBatSyntax = true;
        systemd = {
          enable = true;
        };
      };
    };
  };
}
