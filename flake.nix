{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      nixos-hardware,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      otto-kde-theme = pkgs.stdenvNoCC.mkDerivation {
        pname = "otto-kde-theme";
        version = "2025-01-17";

        src = pkgs.fetchzip {
          url = "https://gitlab.com/jomada/otto/-/archive/55a8dc6e2de4b7b2c8c171b4a36e87b71104da21/otto-55a8dc6e2de4b7b2c8c171b4a36e87b71104da21.tar.gz";
          hash = "sha256-58Aqiu/umLmedGldZJMWEkk/5bs05Pl4+rrKfAs4lyA=";
        };

        installPhase = ''
          install -d \
            $out/share/aurorae/themes \
            $out/share/color-schemes \
            $out/share/Kvantum \
            $out/share/konsole \
            $out/share/latte-layouts \
            $out/share/org.kde.syntax-highlighting/themes \
            $out/share/plasma/desktoptheme \
            $out/share/plasma/look-and-feel \
            $out/share/wallpapers

          cp -r aurorae/Otto $out/share/aurorae/themes/
          cp -r color-schemes/*.colors $out/share/color-schemes/
          cp -r kate/*.theme $out/share/org.kde.syntax-highlighting/themes/
          cp -r konsole/*.colorscheme $out/share/konsole/
          cp -r kvantum/Otto $out/share/Kvantum/
          cp -r "Latte layout"/*.layout.latte $out/share/latte-layouts/
          cp -r Otto $out/share/plasma/desktoptheme/
          cp -r look-and-feel/Otto $out/share/plasma/look-and-feel/
          cp -r wallpaper/Otto $out/share/wallpapers/
        '';

        meta = {
          description = "Otto KDE Plasma theme";
          homepage = "https://gitlab.com/jomada/otto";
          license = pkgs.lib.licenses.gpl3Plus;
          platforms = pkgs.lib.platforms.linux;
        };
      };
    in
    {
      packages.${system} = {
        inherit otto-kde-theme;
      };

      nixosConfigurations = {
        sauls-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix

            # Hardware specific configuration for Framework 13
            nixos-hardware.nixosModules.framework-amd-ai-300-series

            # Home Manager module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # Make all flake inputs available to home.nix
              home-manager.extraSpecialArgs = { inherit inputs; };

              home-manager.users.saul = import ./home.nix;
            }
          ];
        };
      };
    };
}
