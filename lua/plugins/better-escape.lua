return {
  "max397574/better-escape.nvim",
  config = function()
    require("better_escape").setup({
      default_mappings = false,
      mappings = {
        i = { j = { k = "<Esc>", j = "<Esc>" } },
        t = { j = { k = "<C-\\><C-n>", j = "<C-\\><C-n>" } },
      },
    })
  end,
}
