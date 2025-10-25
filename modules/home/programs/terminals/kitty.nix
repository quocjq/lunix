{ ... }: {
  programs.kitty = {
    enable = true;
    themeFile = "OneDark";
    actionAliases = { };
    settings = {
      allow_remote_control = true;
      confirm_os_window_close = 0;
      cursor_trail = 1;
      cursor_trail_start_threshold = 2;
      remember_window_size = true;
    };
  };
}
