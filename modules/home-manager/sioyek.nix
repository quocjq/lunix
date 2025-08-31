{ ... }: {
  programs.sioyek = {
    enable = true;
    bindings = {
      "move_up" = "k";
      "move_down" = "j";
      "move_left" = "h";
      "move_right" = "l";
      "screen_down" = "<C-d>";
      "screen_up" = "<C-u>";
      "fit_to_page_width_smart" = "zz";
      "add_highlight" = "H";
      "keyboard_smart_jump" = "F";
      "open_prev_doc" = "r";
      "search" = "/";
      "add_bookmark" = "m";
      "goto_bookmark" = "'";
      "goto_highlight" = "gh";
      "goto_bookmark_g" = "gB";
      "goto_highlight_g" = "gH";
      "copy" = "y";
      "keyboard_select" = "v";
      "delete_bookmark" = "db";
      "delete_highlight" = "dh";
      "next_item" = "<C-j>";
      "previous_item" = "<C-k>";
      "open_document_embedded" = "o";
      "open_document_embedded_from_current_path" = "O";
    };
    config = {
      "page_separator_width" = "2";
      "startup_commands" = "fit_to_page_width";
      "show_document_name_in_statusbar" = "1";

    };
  };

}
