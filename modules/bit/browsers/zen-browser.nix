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
        { pkgs, ... }:
        {
          imports = [ inputs.zen-browser.homeModules.beta ];
          programs.zen-browser = {
            enable = true;
            setAsDefaultBrowser = true;
            # Betterfox for Zen (yokoffing/Betterfox zen/user.js, aka BetterZen):
            # privacy/telemetry/performance prefs applied as mkDefault settings —
            # any profile `settings` entry wins.
            profiles.default.presets.betterfox.enable = true;
            # arkenfox for Zen (arkenfox/user.js)
            profiles.default.presets.arkenfox.enable = true;
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
