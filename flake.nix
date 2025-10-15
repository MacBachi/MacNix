# ./flake.nix
{
  inputs = {
    # ...existing code...
    mac-app-util.url = "github:hraban/mac-app-util";
    # ...existing code...
  };

  outputs = { self, nix-darwin, home-manager, mac-app-util, ... }:
    {
      darwinConfigurations = {
        MyHost = nix-darwin.lib.darwinSystem {
          # ...existing code...
          modules = [
            # ...existing code...
            mac-app-util.darwinModules.default
            home-manager.darwinModules.home-manager
            (
              { pkgs, config, inputs, ... }:
              {
                home-manager.sharedModules = [
                  mac-app-util.homeManagerModules.default
                ];
                # ...optional: für einzelne User...
                # home-manager.users.mb.imports = [
                #   mac-app-util.homeManagerModules.default
                # ];
              }
            )
            # ...existing code...
          ];
        };
      };
      # ...existing code...
    };
}