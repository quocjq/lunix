# hosts/common/programs.nix
{ pkgs, ... }: {
  # FIX: lua_ls, stylua in nixos can not load without this
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [ lua-language-server stylua ];

  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  programs.ssh.startAgent = true;
}
