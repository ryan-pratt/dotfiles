{
  description = "Flakey McFlakeface";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    xremap-flake.url = "github:xremap/nix-flake";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      microburst = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/microburst
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              backupFileExtension = "bak";
              useGlobalPkgs = true;
              useUserPackages = true;
              users.rpratt = {
                imports = [ ./home/desktop.nix ];
                home.stateVersion = "26.05";
              };
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };

      inversion = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/inversion
          inputs.xremap-flake.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            services.xremap = {
              enable = true;
              config.modmap = [
                {
                  name = "Better ctrl";
                  remap = { "CapsLock" = "Ctrl_L"; };
                }
                {
                  name = "Better caps";
                  remap = {
                    Shift_L = {
                      held = "Shift_L";
                      alone = "CapsLock"; 
                      alone_timeout_millis = 200;
                    };
                  };
                }
              ];
            };
            home-manager = {
              backupFileExtension = "bak";
              useGlobalPkgs = true;
              useUserPackages = true;
              users.rpratt = {
                imports = [ ./home/desktop.nix ];
                home.stateVersion = "26.05";
              };
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };
    };
  };
}
