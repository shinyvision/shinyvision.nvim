return {
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    require("rose-pine").setup({
      -- disable_background = true, -- removes background color
      -- disable_float_background = true,
      styles = {
        bold = true,
        italic = true,
        transparency = true,
      }
    })
    vim.cmd("colorscheme rose-pine")
  end
}
