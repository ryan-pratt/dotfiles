{
  description = "Flakey McFlakeface";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    # ghostty.url = "github:ghostty-org/ghostty";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, zen-browser, ... }: {
    nixosConfigurations = {
      nixos-macbook = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./configuration.nix
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
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.rpratt = ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
          }
        ];
      };
    };
  };
}
