{
  bit.desktop.fonts = {

    homeManager = {pkgs, ...}:{
    home.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove
      nerd-fonts.iosevka
      nerd-fonts.symbols-only
    ];
        };
};
}
