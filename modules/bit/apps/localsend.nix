_: {
  bit.apps.localsend = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.localsend
        ];
      };
  };
}
