{
  description = "";

  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, devshell, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlays.default ];
        };
      in
      {
        packages = rec {
          release = { };
          default = release;
        };

        devShells = {
          default = pkgs.devshell.mkShell {
            packages = with pkgs; [
              gopls
            ];

            env = [
              { name = "TEST"; value = "some_value"; }
            ];
            commands = [
              {
                name = "test";
                help = "test command";
                command = "echo hello_world";
                category = "test";
              }
            ];
          };
        };

      }
    );
}

