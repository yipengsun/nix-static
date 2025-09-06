{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { nixpkgs, ... }:
    let
      forSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];

      overlay = import ./overlay;

      pkgsFactory =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
    in
    {
      packages = forSystems (
        system:
        let
          pkgs = pkgsFactory system;
        in
        rec {
          default = nixStatic;

          curl = pkgs.curl;
          curlStatic = pkgs.pkgsStatic.curl;

          nix = pkgs.nix;
          nixStatic = pkgs.pkgsStatic.nix.out;

          patchelfStatic = pkgs.pkgsStatic.patchelf;
        }
      );
    };
}
