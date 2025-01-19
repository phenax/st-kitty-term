{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, nixpkgs, ... }:
    let
      nixp = import nixpkgs { system = "x86_64-linux"; };
      pkgs = nixp.pkgs;
      buildInputs = with pkgs; [ xorg.libX11 xorg.libXft fontconfig ncurses ];
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [ pkg-config ];
        buildInputs = buildInputs ++ (with pkgs; [
          # clang-tools
        ]);
      };

      packages.x86_64-linux.default = pkgs.stdenv.mkDerivation rec {
        name = "st-${version}";
        version = "0.9.4";

        src = ./.;

        nativeBuildInputs = with pkgs; [ pkg-config ];
        inherit buildInputs;

        unpackPhase = ''cp -r $src/* .'';

        buildPhase = ''make'';

        installPhase = ''TERMINFO=$out/share/terminfo make PREFIX=$out DESTDIR="" install'';
      };
    };
}
