{
  inputs,
  cell,
}: let
  # The `inputs` attribute allows us to access all of our flake inputs.
  inherit (inputs) nixpkgs std;

  # This is a common idiom for combining lib with builtins.
  l = nixpkgs.lib // builtins;
in {
  default = with cell.pkgs.default;
    buildGoApplication rec {
      pname = "put2aria";
      version = "0.0.1";
      pwd = inputs.self;
      src = inputs.self;
      modules = "${inputs.self}/gomod2nix.toml";
      doCheck = false;
    };
}
