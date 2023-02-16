{
    description = "Prehonor NixOS";
    inputs = {
    
      nixpkgs_flake.url = "github:NixOS/nixpkgs/nixos-22.11";
      # hyprland.url = "github:hyprwm/Hyprland";
      # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; nixos-22.11
      # nixos-hardware.url = github:NixOS/nixos-hardware/master;
      # emacs-overlay.url = "github:nix-community/emacs-overlay/7ba0cd76c4e5cbd4a8ac7387c8ad2493caa800f0";
      # nur.url = "github:nix-community/NUR";
      home-manager = {
        url = "github:nix-community/home-manager/release-22.11";
        inputs.nixpkgs.follows = "nixpkgs_flake";
      };
    };
    outputs = { self, nixpkgs_flake,home-manager }@attrs: 
    let
      system = "x86_64-linux";
      hm-module = [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.prehonor = import /home/prehonor/.config/nixpkgs/home.nix;
          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    in
    {
      nixosConfigurations = {
        prehonor = nixpkgs_flake.lib.nixosSystem {
          inherit system;
          specialArgs = attrs; #  // { inputs = self.inputs; }
          modules = [ 
            ./configuration.nix 
            # hyprland.nixosModules.default
            # {programs.hyprland.enable = true;}
          ] ++ hm-module;
        };
      };
      /*
      homeConfigurations = (
        import ./outputs/home-conf.nix {
          inherit system home-manager;
          nixpkgs_flake = nixpkgs_flake;
        }
      );
      */
    };
}
