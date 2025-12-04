# modules/home-manager/git.nix
{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Lunixose";
        email = "quocjq@gmail.com";
      };

      init.defaultBranch = "main";
      core.editor = "emacs";
      pull.rebase = false;
    };
  };
}
