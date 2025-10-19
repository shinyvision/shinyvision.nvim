return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPre",
    opts = {
      indent = { char = "│", tab_char = "│" },
      scope  = {
        enabled = true,
        show_start = true,
        show_end = false,
        injected_languages = false,
        highlight = { "Function", "Label" },
        priority = 500,
      }
    },
    config = function(_, opts)
      local hooks = require("ibl.hooks")

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        -- dim guides → same fg as Comment
        -- vim.api.nvim_set_hl(0, "IblIndent", { link = "Comment", nocombine = true })
        vim.api.nvim_set_hl(0, "IblIndent", { fg = "#211f2f", nocombine = true })
        -- focused block → whatever your scheme uses for “accent”
        vim.api.nvim_set_hl(0, "IblScope", { link = "Function", nocombine = true })
        -- change "Function" to "Identifier", "String", etc. if that
        -- matches your accent colour better.
      end)

      require("ibl").setup(opts)
    end,
  },
}
