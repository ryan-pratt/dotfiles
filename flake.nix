{
  description = "Flakey McFlakeface";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # ghostty.url = "github:ghostty-org/ghostty";
  };

  outputs = { self, nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      nixos-macbook = lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./configuration.nix ];
      };
    };
  };
}
