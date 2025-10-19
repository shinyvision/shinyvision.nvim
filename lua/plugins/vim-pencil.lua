return {
  "preservim/vim-pencil",
  ft = { "markdown", "text" },
  config = function()
    vim.g["pencil#wrapModeDefault"] = "soft"
    vim.g["pencil#textwidth"] = 74
    vim.g["pencil#conceallevel"] = 2
    vim.g["pencil#concealcursor"] = ""

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "text" },
      callback = function()
        vim.cmd("call pencil#init({'wrap': 'soft', 'autoformat': 1, 'conceal': 1})")
      end,
    })
  end,
}
