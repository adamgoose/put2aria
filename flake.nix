{
  description = "put2aria";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv/v1.1";
    gomod2nix.url = "github:nix-community/gomod2nix/v1.6.0";
    gomod2nix.inputs.nixpkgs.follows = "nixpkgs";

    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw= cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=";
    extra-substituters = "https://devenv.cachix.org https://cache.garnix.io";
  };

  outputs = {std, ...} @ inputs:
    std.growOn
    {
      inherit inputs;
      cellsFrom = ./nix;
      cellBlocks = with std.blockTypes; [
        (pkgs "pkgs")
        (runnables "apps")
        (devshells "shells")
        (functions "nixosModules")
      ];
    }
    {
      devShells = std.harvest inputs.self ["put2aria" "shells"];

      packages = std.harvest inputs.self [
        ["put2aria" "apps"]
      ];

      nixosModules = std.harvest inputs.self [
        ["put2aria" "nixosModules"]
      ];
    };
}
