{
  bit.apps.proton-pass = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.proton-pass
        ];
      };
  };
}
