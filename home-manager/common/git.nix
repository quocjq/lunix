# modules/home-manager/git.nix
{ ... }: {
  programs.git = {
    enable = true;
    userName = "Lunixose";
    userEmail = "quocjq@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = false;
    };
  };
}
