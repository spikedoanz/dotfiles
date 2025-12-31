# lib/mksystem.nix - Simple system builder
{ inputs }:

name: { system, darwin ? false }:

let
  systemBuilder = if darwin
    then inputs.darwin.lib.darwinSystem
    else inputs.nixpkgs.lib.nixosSystem;

  homeManagerModule = if darwin
    then inputs.home-manager.darwinModules.home-manager
    else inputs.home-manager.nixosModules.home-manager;

in systemBuilder {
  inherit system;

  specialArgs = { inherit inputs; };

  modules = [
    ../machines/${name}

    homeManagerModule
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
    }
  ];
}
