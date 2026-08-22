{ inputs, ... }: {
  flake-file.inputs = {
    #niri = {
    #  url = "github:sodiboo/niri-flake"; # this flake is currently unmaintained, so we will use a fork of it
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    niri = {
      url = "github:epireyn/niri-flake"; # this flake is currently unmaintained, so we will use a fork of it
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix"; # sets the hash to the latest build stored by cachix
      #url = "github:noctalia-dev/noctalia";
      #inputs.nixpkgs.follows = "nixpkgs"; # this line is optional, prevents downloading two versions of nixpkgs but disables cache
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  flake-file.nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      #"https://niri.cachix.org"
      "https://niri-epiryen.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      #"niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="
    ];
  };

  bit.desktop.niri = {
    nixos = {
      imports = [
        #inputs.niri.nixosModules.niri
        inputs.noctalia-greeter.nixosModules.default
      ];
      #niri-flake.cache.enable = true;
      programs.noctalia = {
        #enable = true;
        #recommendedServices.enable = true;
        ##systemd.enable = true;
        #systemd.target = "niri-session.target";
      };
      programs.noctalia-greeter = {
        enable = true;
      };
      programs.niri = {
        enable = true;
      };
      nix.settings = {
        substituters = [
          "https://noctalia.cachix.org"
          #"https://niri.cachix.org"
          "https://niri-epiryen.cachix.org"
        ];
        trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          #"niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
          "niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="
        ];

      };
      services.logind.settings.Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
      };
    };
    homeManager =
      {
        config,
        pkgs,
        host,
        ...
      }:
      {
        imports = [
          inputs.noctalia.homeModules.default
          inputs.niri.homeModules.niri
          #inputs.niri.homeModules.stylix
	  inputs.stylix.homeModules.stylix
        ];
        programs.noctalia = {
          enable = true;
          systemd.enable = true;
          settings = {
            shell.niri_overview_type_to_launch_enabled = true;
	    shell.launch_apps_as_systemd_services = true;
          };
        };
	#stylix.targets.noctalia.enable = true;
	stylix.targets.noctalia.enable = "garbage";
        programs.niri = {
          enable = true;
          #package = inputs.niri.packages.${host.system}.niri-unstable;
          package = pkgs.niri;
          settings = {
            input = {
              keyboard = {
                repeat-rate = 50;
                repeat-delay = 300;
                #xkb = "caps:swapescape";
              };
              touchpad = {
                tap = true;
                dwt = true; # disable while typing
                natural-scroll = true;
              };
              mouse = {
                accel-profile = "flat";
              };
              power-key-handling.enable = true;
              focus-follows-mouse.enable = true;
            };
            switch-events.lid-close.action.spawn = [
              "noctalia"
              "msg"
              "session"
              "lock-and-suspend"
            ];
            layout = {
              gaps = 16;
              center-focused-column = "never";
              preset-column-widths = [
                { proportion = 1. / 3.; }
                { proportion = 1. / 2.; }
                { proportion = 2. / 3.; }

                # { fixed = 1920; }
              ];
              focus-ring = {
                enable = true;
                width = 4;
              };
              shadow = {
                enable = true;
                softness = 30;
                spread = 5;
                offset = {
                  x = 0;
                  y = 5;
                };
              };
            };
            layer-rules = [
              {
                matches = [
                  { namespace = "^noctalia-backdrop"; }
                ];
                place-within-backdrop = true;
              }
            ];
            window-rules = [
              {
                geometry-corner-radius = {
                  bottom-left = 20.0;
                  bottom-right = 20.0;
                  top-left = 20.0;
                  top-right = 20.0;
                };
                clip-to-geometry = true;
              }
              {
                matches = [ { app-id = "dev.noctalia.Noctalia"; } ];
                open-floating = true;
                default-column-width.fixed = 1080;
                default-window-height.fixed = 920;
              }
            ];
            screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
            #hotkey-overlay.skip-at-startup = true;
            binds = {
              "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];
              "Mod+T".action.spawn = "ghostty";
              "Mod+Space".action.spawn-sh = "noctalia msg panel-toggle launcher";
              "Mod+S".action.spawn-sh = "noctalia msg panel-toggle control-center";
              "Mod+Semicolon".action.spawn-sh = "noctalia msg settings-toggle";
              "XF86AudioRaiseVolume".action.spawn-sh = "noctalia msg volume-up";
              "XF86AudioLowerVolume".action.spawn-sh = "noctalia msg volume-down";
              "XF86AudioMute".action.spawn-sh = "noctalia msg volume-mute";
              "XF86MonBrightnessUp".action.spawn-sh = "noctalia msg brightness-up";
              "XF86MonBrightnessDown".action.spawn-sh = "noctalia msg brightness-down";
              "Alt+Tab".action.spawn-sh = "noctalia msg window-switcher";
              "Mod+O" = {
                repeat = false;
                action.toggle-overview = [ ];
              };
              "Mod+Q" = {
                repeat = false;
                action.close-window = [ ];
              };
              "Mod+Left".action.focus-column-left = [ ];
              "Mod+Down".action.focus-window-down = [ ];
              "Mod+Up".action.focus-window-up = [ ];
              "Mod+Right".action.focus-column-right = [ ];
              "Mod+H".action.focus-column-left = [ ];
              "Mod+J".action.focus-window-down = [ ];
              "Mod+K".action.focus-window-up = [ ];
              "Mod+L".action.focus-column-right = [ ];
              "Mod+Ctrl+Left".action.move-column-left = [ ];
              "Mod+Ctrl+Down".action.move-window-down = [ ];
              "Mod+Ctrl+Up".action.move-window-up = [ ];
              "Mod+Ctrl+Right".action.move-column-right = [ ];
              "Mod+Ctrl+H".action.move-column-left = [ ];
              "Mod+Ctrl+J".action.move-window-down = [ ];
              "Mod+Ctrl+K".action.move-window-up = [ ];
              "Mod+Ctrl+L".action.move-column-right = [ ];
              "Mod+Home".action.focus-column-first = [ ];
              "Mod+End".action.focus-column-last = [ ];
              "Mod+Ctrl+Home".action.move-column-to-first = [ ];
              "Mod+Ctrl+End".action.move-column-to-last = [ ];
              "Mod+Shift+Left".action.focus-monitor-left = [ ];
              "Mod+Shift+Down".action.focus-monitor-down = [ ];
              "Mod+Shift+Up".action.focus-monitor-up = [ ];
              "Mod+Shift+Right".action.focus-monitor-right = [ ];
              "Mod+Shift+H".action.focus-monitor-left = [ ];
              "Mod+Shift+J".action.focus-monitor-down = [ ];
              "Mod+Shift+K".action.focus-monitor-up = [ ];
              "Mod+Shift+L".action.focus-monitor-right = [ ];
              "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [ ];
              "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [ ];
              "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [ ];
              "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [ ];
              "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [ ];
              "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = [ ];
              "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = [ ];
              "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [ ];
              "Mod+Page_Down".action.focus-workspace-down = [ ];
              "Mod+Page_Up".action.focus-workspace-up = [ ];
              "Mod+U".action.focus-workspace-down = [ ];
              "Mod+I".action.focus-workspace-up = [ ];
              "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [ ];
              "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [ ];
              "Mod+Ctrl+U".action.move-column-to-workspace-down = [ ];
              "Mod+Ctrl+I".action.move-column-to-workspace-up = [ ];
              "Mod+Shift+Page_Down".action.move-workspace-down = [ ];
              "Mod+Shift+Page_Up".action.move-workspace-up = [ ];
              "Mod+Shift+U".action.move-workspace-down = [ ];
              "Mod+Shift+I".action.move-workspace-up = [ ];

              "Mod+WheelScrollDown" = {
                cooldown-ms = 150;
                action.focus-workspace-down = [ ];
              };
              "Mod+WheelScrollUp" = {
                cooldown-ms = 150;
                action.focus-workspace-up = [ ];
              };
              "Mod+Ctrl+WheelScrollDown" = {
                cooldown-ms = 150;
                action.move-column-to-workspace-down = [ ];
              };
              "Mod+Ctrl+WheelScrollUp" = {
                cooldown-ms = 150;
                action.move-column-to-workspace-up = [ ];
              };

              "Mod+WheelScrollRight".action.focus-column-right = [ ];
              "Mod+WheelScrollLeft".action.focus-column-left = [ ];
              "Mod+Ctrl+WheelScrollRight".action.move-column-right = [ ];
              "Mod+Ctrl+WheelScrollLeft".action.move-column-left = [ ];
              "Mod+Shift+WheelScrollDown".action.focus-column-right = [ ];
              "Mod+Shift+WheelScrollUp".action.focus-column-left = [ ];
              "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = [ ];
              "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = [ ];

              "Mod+1".action.focus-workspace = 1;
              "Mod+2".action.focus-workspace = 2;
              "Mod+3".action.focus-workspace = 3;
              "Mod+4".action.focus-workspace = 4;
              "Mod+5".action.focus-workspace = 5;
              "Mod+6".action.focus-workspace = 6;
              "Mod+7".action.focus-workspace = 7;
              "Mod+8".action.focus-workspace = 8;
              "Mod+9".action.focus-workspace = 9;
              "Mod+Ctrl+1".action.move-column-to-workspace = 1;
              "Mod+Ctrl+2".action.move-column-to-workspace = 2;
              "Mod+Ctrl+3".action.move-column-to-workspace = 3;
              "Mod+Ctrl+4".action.move-column-to-workspace = 4;
              "Mod+Ctrl+5".action.move-column-to-workspace = 5;
              "Mod+Ctrl+6".action.move-column-to-workspace = 6;
              "Mod+Ctrl+7".action.move-column-to-workspace = 7;
              "Mod+Ctrl+8".action.move-column-to-workspace = 8;
              "Mod+Ctrl+9".action.move-column-to-workspace = 9;
              "Mod+Tab".action.focus-workspace-previous = [ ];
              "Mod+BracketLeft".action.consume-or-expel-window-left = [ ];
              "Mod+BracketRight".action.consume-or-expel-window-right = [ ];
              "Mod+Comma".action.consume-window-into-column = [ ];
              "Mod+Period".action.expel-window-from-column = [ ];
              "Mod+R".action.switch-preset-column-width = [ ];
              "Mod+Shift+R".action.switch-preset-column-width-back = [ ];
              "Mod+Ctrl+Shift+R".action.switch-preset-window-height = [ ];
              "Mod+Ctrl+R".action.reset-window-height = [ ];
              "Mod+F".action.maximize-column = [ ];
              "Mod+Shift+F".action.fullscreen-window = [ ];
              "Mod+M".action.maximize-window-to-edges = [ ];
              "Mod+Ctrl+F".action.expand-column-to-available-width = [ ];
              "Mod+C".action.center-column = [ ];
              "Mod+Ctrl+C".action.center-visible-columns = [ ];
              "Mod+Minus".action.set-column-width = "-10%";
              "Mod+Equal".action.set-column-width = "+10%";
              "Mod+Shift+Minus".action.set-window-height = "-10%";
              "Mod+Shift+Equal".action.set-window-height = "+10%";
              "Mod+V".action.toggle-window-floating = [ ];
              "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [ ];
              "Mod+W".action.toggle-column-tabbed-display = [ ];

              "Print".action.screenshot = [ ];
              "Ctrl+Print".action.screenshot-screen = [ ];
              "Alt+Print".action.screenshot-window = [ ];
              "Mod+Escape" = {
                action.toggle-keyboard-shortcuts-inhibit = [ ];
                allow-inhibiting = false;
              };
              "Mod+Shift+E".action.quit = [ ];
              "Ctrl+Alt+Delete".action.quit = [ ];
              "Mod+Shift+P".action.power-off-monitors = [ ];
            };
          };
        };
      };
  };
}
