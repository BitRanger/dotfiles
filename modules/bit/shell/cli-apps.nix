{
  bit.shell.cli-apps = {
    nixos = {
    };
    homeManager =
      { pkgs, ... }:
      {
        programs = {
          bat = {
            enable = true;
          };
          btop = {
            enable = true;
            package = pkgs.btop.override { rocmSupport = true; };
          };
          fastfetch = {
            enable = true;
          };
          fzf = {
            enable = true;
	    historyWidget.command = ""; # needed because of a bind conflict between atuin and fzf on history Ctrl-r bind
            enableFishIntegration = true;
          };
          lsd = {
            enable = true;
            enableFishIntegration = true;
          };
          navi = {
            enable = true;
            enableFishIntegration = true;
          };
          yazi = {
            enable = true;
            enableFishIntegration = true;

          };
          atuin = {
            enable = true;
            enableFishIntegration = true;
          };
          broot = {
            enable = true;
            enableFishIntegration = true;
          };
          lazygit = {
            enable = true;
            enableFishIntegration = true;
          };
          zellij = {
            enable = true;
            enableFishIntegration = false; # this makes fish spawn zellij every time
          };
          zoxide = {
            enable = true;
            enableFishIntegration = true;
          };
	  starship = {
	    enable = true;
            enableFishIntegration = true;
	  };
        };
        home.packages = with pkgs; [
          ripgrep
          fd
          git
          unzip
          bc # arbitrary-precision calculator
          ncdu # disk usage analyzer
          nix-diff # compare derivations
          nix-output-monitor # nicer build logs
          nixd # Nix language server
          nixfmt # Nix formatter
          nvd # Nix version diff
        ];
      };
  };
}
