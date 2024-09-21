{
  inputs,
  cell,
}: let
  inherit (inputs) devenv;
  pkgs = cell.pkgs.default;
in {
  default = devenv.lib.mkShell {
    inherit inputs pkgs;
    modules = [
      ({pkgs, ...}: {
        dotenv.disableHint = true;

        languages.go.enable = true;

        packages = with pkgs; [
          gomod2nix
        ];

        pre-commit.hooks = {
          gomod2nix = {
            enable = true;
            entry = "${pkgs.gomod2nix}/bin/gomod2nix";
            files = "go.mod|go.sum";
            pass_filenames = false;
          };
        };
      })
    ];
  };
}
