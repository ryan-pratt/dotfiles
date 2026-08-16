{
  description = "Flakey McFlakeface";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
    xremap-flake.url = "github:xremap/nix-flake";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      hailstone = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/hailstone
          inputs.apple-silicon.nixosModules.apple-silicon-support
          inputs.xremap-flake.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            # services.openvpn.servers = {
            #   fast = {
            #     config = '' /etc/openvpn-conf/f.udp.ovpn '';
            #     updateResolvConf = true;
            #   };
            #   secure = {
            #     config = '' /etc/openvpn-conf/s.udp.ovpn '';
            #     updateResolvConf = true;
            #   };
            # };
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
                home.stateVersion = "25.11";
              };
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };

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
    };
  };
}
