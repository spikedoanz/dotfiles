{
  description = "spike's dotfiles - nix-darwin + home-manager";

  inputs = {
    # Use nixpkgs unstable for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # nix-darwin for macOS system management
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager for user environment
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }@inputs:
    let
      mkSystem = import ./lib/mksystem.nix { inherit inputs; };
    in
    {
      # macOS
      darwinConfigurations.macbook = mkSystem "macbook" {
        system = "aarch64-darwin";
        darwin = true;
      };
      darwinConfigurations.softmacs = mkSystem "macbook" {
        system = "aarch64-darwin";
        darwin = true;
      };

      # Linux (uncomment when ready)
      # nixosConfigurations.clinky = mkSystem "clinky" {
      #   system = "x86_64-linux";
      # };
    };
}
