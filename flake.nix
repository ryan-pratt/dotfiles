{
  description = "Flakey McFlakeface";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # zen-browser = {
    #   url = "github:0xc000022070/zen-browser-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # ghostty.url = "github:ghostty-org/ghostty";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      nixos-macbook = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.rpratt = ./home.nix;
          }
        ];
      };
    };
  };
}
