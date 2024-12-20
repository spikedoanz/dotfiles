{ config, pkgs, ... }:

{

  home.username = "spike";
  home.homeDirectory = "/home/spike";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "spikedoanz@gmail.com";
    userName = "spikedoanz";
  };

  home.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
  fonts.fontconfig.enable = true;        
}
