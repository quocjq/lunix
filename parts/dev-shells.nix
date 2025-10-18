# parts/dev-shells.nix
{ inputs, ... }: {
  perSystem = { config, self', inputs', pkgs, system, ... }: {
    devShells.default = pkgs.mkShell {
      name = "Lunixose's shell";
      # An temporary shell for install lunix for first time, still wip.

      buildInputs = with pkgs; [
        # Nix tools
        nix-output-monitor
        nh

        # Development tools
        git
        just
      ];

      shellHook = ''
        echo "🚀 Welcome to LUNIXOS!"
        echo ""
        echo "Available commands:"
        echo "  nixos-rebuild switch --flake .#<host>  - Rebuild system for specific host"
        echo "  home-manager switch --flake .#<user>@<host>  - Rebuild home-manager config"
        echo "  just --list  - Show available just commands"
        echo ""
        echo "Available hosts: nixos"
        echo ""
      '';
    };
  };
}
