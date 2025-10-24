{ ... }: {
  perSystem = { config, self', inputs', pkgs, system, ... }: {
    devShells.default = pkgs.mkShell {
      name = "Lunixose's shell";

      buildInputs = with pkgs; [ nix-output-monitor nh git just ];

      shellHook = ''
        echo "🚀 Welcome to LUNIXOS!"
        echo ""
        echo "Available commands:"
        echo "  nixos-rebuild switch --flake .#<host>  - Rebuild system"
        echo "  home-manager switch --flake .#<user>@<host>  - Rebuild home"
        echo "  just --list  - Show available just commands"
        echo ""
      '';
    };
  };
}
