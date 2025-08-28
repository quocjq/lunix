return {
  'lukas-reineke/indent-blankline.nvim',
  opts = function()
    return {
      indent = {
        char = '│',
        tab_char = '│',
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = {
          'help',
          'lazy',
          'mason',
          'neo-tree',
          'dashboard',
        },
      },
    }
  end,
  main = 'ibl',
}
