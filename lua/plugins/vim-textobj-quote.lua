return {
  "preservim/vim-textobj-quote",
  dependencies = { "kana/vim-textobj-user" },

  -- only load in prose buffers
  ft = { "markdown", "plaintex", "gitcommit", "text" },

  init = function()
    -- keep the auto-curly-quotes feature
    vim.g["textobj#quote#educate"] = 1

    -- ***disable the text-object part so mini.ai owns `aq/iq`***
    vim.g["textobj#quote#doubleMotion"] = "" -- no "double-quote" object
    vim.g["textobj#quote#singleMotion"] = "" -- no 'single-quote' object
  end,

  config = function()
    -- initialise the plugin when we open a prose buffer
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "markdown", "plaintex", "gitcommit", "text" },
      callback = function()
        vim.fn["textobj#quote#init"] { educate = 1 } -- keep “educate”
      end,
    })

    -- mappings for the replace feature (unchanged)
    local map = vim.keymap.set
    map({ "n", "x" }, "<leader>rc", "<Plug>ReplaceWithCurly", { silent = true, desc = "ASCII → curly quotes" })
    map({ "n", "x" }, "<leader>rs", "<Plug>ReplaceWithStraight", { silent = true, desc = "Curly → ASCII quotes" })
  end,
}
