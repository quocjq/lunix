# parts/dev-shells.nix
{ inputs, ... }: {
  perSystem = { config, self', inputs', pkgs, system, ... }: {
    devShells.default = pkgs.mkShell {
      name = "Lunixose's shell";

      buildInputs = with pkgs; [
        # Nix tools
        nil # Nix language server
        nix-output-monitor
        nh # Nice nix helper
        nvd # Nix version diff

        # Git and development tools
        git
        pre-commit

        # System tools
        just
      ];

      shellHook = ''
        echo "🚀 Welcome to the NixOS Configuration Development Shell!"
        echo ""
        echo "Available commands:"
        echo "  nixos-rebuild switch --flake .#<host>  - Rebuild system for specific host"
        echo "  home-manager switch --flake .#<user>@<host>  - Rebuild home-manager config"
        echo "  just --list  - Show available just commands"
        echo ""
        echo "Available hosts: nixos, laptop, server"
        echo ""
      '';
    };
  };
}
