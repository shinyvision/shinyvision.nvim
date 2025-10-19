return {
  "echasnovski/mini.files",
  config = function()
    local MiniFiles = require "mini.files"
    local function minifiles_win()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "minifiles" then return win end
      end
    end
    local function toggle_explorer()
      local win = minifiles_win()
      if win then
        vim.api.nvim_win_close(win, true)
      else
        local file = vim.api.nvim_buf_get_name(0)
        if file ~= "" then
          -- Check if file exists, if not, traverse up to parent directories
          while file ~= "" and not vim.uv.fs_stat(file) do
            file = vim.fn.fnamemodify(file, ":h")
          end
        end
        MiniFiles.open(file ~= "" and file or vim.uv.cwd())
      end
    end
    vim.keymap.set("n", "<leader>e", toggle_explorer, { desc = "MiniFiles: toggle", silent = true })
    MiniFiles.setup {
      mappings = {
        go_out_plus = "",
      },
      content = {
        filter = function(entry)
          if entry.fs_type == 'directory' then
            return true
          end
          if entry.name:match('_templ%.go$') then
            return false
          end
          return true
        end,
      },
      options = {
        use_as_default_explorer = false,
      },
    }
  end,
}
