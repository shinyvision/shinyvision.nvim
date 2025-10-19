return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    keys = {
      { "zR", function() require("ufo").openAllFolds() end,         desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end,        desc = "Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open non-block folds" },
      { "zm", function() require("ufo").closeFoldsWith() end,       desc = "Close folds (granular)" },
    },
    opts = {
      -- Prefer Treesitter, fall back to indent
      provider_selector = function(_, filetype)
        local ft_map = { vim = "indent", python = { "treesitter", "indent" } }
        return ft_map[filetype] or { "treesitter", "indent" }
      end,
      open_fold_hl_timeout = 150,
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          winblend = 0,
        },
      },
    },
    config = function(_, opts)
      vim.o.foldcolumn     = "1"
      vim.o.foldlevel      = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable     = true
      vim.opt.fillchars:append {
        foldopen  = "",
        foldclose = "",
        foldsep   = " ",
        fold      = " ",
        eob       = " ",
      }

      require("ufo").setup(opts)
    end,
  },
}
