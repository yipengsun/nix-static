{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      overlay = import ./overlay.nix;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          };
        in
        rec {
          default = nixStatic;

          curl = pkgs.curl;
          curlStatic = pkgs.pkgsStatic.curl;

          gitStatic = pkgs.pkgsStatic.git;

          nix = pkgs.nix;
          nixStatic = pkgs.pkgsStatic.nix.out;
        }
      );
    };
}
