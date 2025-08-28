-- ~/.config/nvim/lua/plugins/autopair.lua
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp" },
  opts = {
    map_cr = true,
    check_ts = true, -- Check treesitter
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      java = false,
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    -- Add the fast wrap feature
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      offset = 0, -- Offset from pattern match
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "PmenuSel",
      highlight_grey = "LineNr",
    },
  },
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local conds = require("nvim-autopairs.conds")

    npairs.setup(opts)

    -- ==========================================================
    -- Helper function for conditional insertion with surrounding check
    -- ==========================================================
     local function rule2(a1, ins, a2, lang)
      npairs.add_rule(
        Rule(ins, ins, lang)
          :with_pair(function(opts)
            if opts.col == 0 then return false end
            return a1 .. a2 == opts.line:sub(opts.col - #a1, opts.col + #a2 - 1)
          end)
          :with_move(conds.none())
          :with_cr(conds.none())
          :with_del(function(opts)
            if opts.col == 0 then return false end
            local col = vim.api.nvim_win_get_cursor(0)[2]
            return a1 .. ins .. ins .. a2 == opts.line:sub(col - #a1 - #ins + 1, col + #ins + #a2)
          end)
      )
    end

    -- ## Add custom rules ##
    rule2("(", " ", ")")
    rule2("{", " ", "}")
    rule2("[", " ", "]")
    rule2("$", " ", "$")
    npairs.add_rule(Rule("$", "$", { "tex", "typst" }))

  end,
}


