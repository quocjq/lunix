{ ... }: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export EDITOR="e"
      alias f="ranger"
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      alias rebuilds="sudo nixos-rebuild switch --flake ~/Lunix"
      alias opt="sudo nix store optimise"
      alias clean="sudo nh clean all --ask --keep 5"
      alias rebuild="nh os switch ~/Lunix"
      alias buildtest="nh os switch --dry ~/Lunix"
      alias e="nvim"
      alias search="nh search"
      alias la="eza -a"
      alias ll="eza -l"
    '';
    shellAliases = { };
  };

}
