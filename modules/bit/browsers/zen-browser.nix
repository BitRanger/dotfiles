{ inputs, ... }:
{
  flake-file.inputs.zen-browser = {
    url = "github:0xc000022070/zen-browser-flake";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };
  flake-file.inputs.firefox-addons = {
    url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  bit.browsers.zen-browser =
    { host, ... }:
    {
      homeManager =
        { lib, ... }:
        {
          imports = [ inputs.zen-browser.homeModules.beta ];
          stylix.targets.zen-browser.enable = true;
          stylix.targets.zen-browser.profileNames = [ "default" ];
          stylix.targets.zen-browser.enableCss = true;
          stylix.targets.zen-browser.opacityHex = lib.mkForce "1A";
          programs.zen-browser = {
            enable = true;
            setAsDefaultBrowser = true;
            # Betterfox for Zen (yokoffing/Betterfox zen/user.js, aka BetterZen):
            # privacy/telemetry/performance prefs applied as mkDefault settings —
            # any profile `settings` entry wins.
            profiles.default.presets.betterfox.enable = true;
            # arkenfox for Zen (arkenfox/user.js)
            profiles.default.presets.arkenfox.enable = true;
            profiles.default.containers = {
              personal = {
                id = 1;
                name = "Personal";
                color = "blue";
                icon = "fingerprint";
              };
              college = {
                id = 2;
                name = "College";
                color = "red";
                icon = "fruit";
              };
              dev = {
                id = 3;
                name = "Dev";
                color = "purple";
                icon = "briefcase";
              };
              chill = {
                id = 4;
                name = "Chill";
                color = "yellow";
                icon = "chill";
              };
            };
            profiles.default.spacesForce = true; # Delete spaces not declared here
            profiles.default.spaces = {
              "Personal" = {
                id = "c9dd1ce0-2750-4c16-a398-43cd615291ac";
                container = 1;
                position = 0;
                icon = "🏠";
              };
              "College" = {
                id = "9641fa73-b023-4c6f-a116-8fd835278c8c";
                container = 2;
                position = 1;
                icon = "📚";
              };
              "Dev" = {
                id = "020c3c06-810f-4ac5-9274-79fd60804843";
                container = 3;
                position = 2;
                icon = "💾";
              };
              "Chill" = {
                id = "43da2845-f2a9-4354-b533-4926ec55c1c8";
                container = 4;
                position = 3;
                icon = "🫠";
              };
            };
            policies = {
              AutofillAddressEnabled = true;
              AutofillCreditCardEnabled = false;
              DisableAppUpdate = true;
              DisableFeedbackCommands = true;
              DisableFirefoxStudies = true;
              DisablePocket = true;
              DisableTelemetry = true;
              DontCheckDefaultBrowser = true;
              NoDefaultBookmarks = true;
              OfferToSaveLogins = false;
              EnableTrackingProtection = {
                Value = true;
                Locked = true;
                Cryptomining = true;
                Fingerprinting = true;
              };
            };
            profiles.default.settings = {
              /**
                use double quotes!
              */
              "zen.workspaces.continue-where-left-off" = true;
              "zen.view.compact.hide-tabbar" = true;
              "zen.urlbar.behavior" = "float";
              "zen.welcome-screen.seen" = true;
              "zen.theme.gradient.show-custom-colors" = true;
              "zen.theme.acrylic-elements" = true;
            };
            # Three-layer configuration overview:
            #
            # 1. policies (top-level, policies.json)
            #    DisableAppUpdate, DisablePocket, etc. — enforced, user can't change
            #
            # 2. policies.Preferences (in policies.json)
            #    Locked preference values like browser.startup.homepage — enforced, user can't change
            #
            # 3. profiles.*.settings (prefs.js)
            #    User preferences like zen.* settings — defaults, user can change in browser
            #
            # Key rules for profiles.*.settings:
            # - ALWAYS quote non-Zen keys: "browser.tabs.warnOnClose" = false;
            # - Don't use nested notation for browser.*: don't do browser = { tabs.warnOnClose = ... }
            # - Zen.* settings work reliably with quoted keys
            # - Settings persist to prefs.js; user can override in browser
            #
            # Troubleshooting settings not persisting: see issue #293
            # https://github.com/0xc000022070/zen-browser-flake/issues/293
            profiles.default.extensions.packages = with inputs.firefox-addons.packages.${host.system}; [
              ublock-origin
              proton-pass
            ];
          };
        };
    };
}
