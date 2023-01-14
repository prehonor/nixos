{
    description = "Prehonor NixOS";
    inputs = {
    
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
      # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
      # nixos-hardware.url = github:NixOS/nixos-hardware/master;
      # emacs-overlay.url = "github:nix-community/emacs-overlay/7ba0cd76c4e5cbd4a8ac7387c8ad2493caa800f0";
      # nur.url = "github:nix-community/NUR";
  
    };
    outputs = { self, nixpkgs }@attrs: {
      nixosConfigurations.prehonor = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs; # 将 inputs 函数的参数添加configuration.nix
        modules = [ ./configuration.nix ];
      };
    };
}
