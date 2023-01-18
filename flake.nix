{
    description = "Prehonor NixOS";
    inputs = {
    
      nixpkgs_flake.url = "github:NixOS/nixpkgs/nixos-22.11";
      # hyprland.url = "github:hyprwm/Hyprland";
      # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable"; nixos-22.11
      # nixos-hardware.url = github:NixOS/nixos-hardware/master;
      # emacs-overlay.url = "github:nix-community/emacs-overlay/7ba0cd76c4e5cbd4a8ac7387c8ad2493caa800f0";
      # nur.url = "github:nix-community/NUR";
  
    };
    outputs = { self, nixpkgs_flake }@attrs: {
      nixosConfigurations.prehonor = nixpkgs_flake.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs; #  // { inputs = self.inputs; }
        modules = [ 
          ./configuration.nix 
          # hyprland.nixosModules.default
          # {programs.hyprland.enable = true;}
        ];
      };
    };
}
