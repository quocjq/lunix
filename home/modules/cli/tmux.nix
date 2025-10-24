{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    mouse = true;
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig = ''
      set -g prefix M-a
      set -g set-clipboard on
      set -g status-position top
      set -g renumber-windows on
      set -g history-limit 1000000
      set -g escape-time 0
      set -g status-right-length 100
      set -g status-left-length 100
      bind -n M-R source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"
      bind C-p previous-window
      bind C-n next-window
      bind -n M-F new-window -c ~/Lunix/ "nvim flake.nix"
      bind -n M-o new-window -c ~/ "tms"
      bind -n M-f new-window -c ~/ "nvim $(fzf)"
      bind -n M-g new-window -c ~/Lunix/ "lazygit" 
      bind -n M-c kill-pane
      bind -n M-q kill-window
      bind -n M-D kill-session -a
    '';
    plugins = with pkgs.tmuxPlugins; [
      nord
      sensible
      yank
      tilish
      tmux-fzf
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
          set -g @continuum-boot 'on'
        '';
      }
      {
        plugin = fzf-tmux-url;
        extraConfig = ''
          set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
          set -g @fzf-url-history-limit '2000'
        '';
      }
    ];

  };

  home.packages = with pkgs; [ tmux-sessionizer ];
}
