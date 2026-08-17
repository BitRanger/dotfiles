{
  bit.apps.lunatask = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.lunatask
        ];
      };
  };
}
