return {
  "rcarriga/nvim-notify",
  lazy = false,
  init = function()
    vim.opt.termguicolors = true
    vim.notify = require("notify")
  end,
  opts = {
    stages = "slide",
    timeout = 3000,
    fps = 60,
    top_down = true,
  },
}
