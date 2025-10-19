return {
  "bradford-smith94/quick-scope",
  event = "VeryLazy",
  init = function()
    vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
    local chars = [[abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_`~!@#$%^&*()-=+[{]}\|;:'",<.>/?]]
    local list = {}
    for c in chars:gmatch(".") do table.insert(list, c) end
    vim.g.qs_accepted_chars = list
  end,
  config = function()
    local function set_qs_hl(bg)
      if bg then
        vim.cmd(
        "highlight QuickScopePrimary guifg=#afff5f guibg=#333333 gui=underline ctermfg=155 ctermbg=236 cterm=underline")
        vim.cmd(
        "highlight QuickScopeSecondary guifg=#5fffff guibg=#333333 gui=underline ctermfg=81 ctermbg=236 cterm=underline")
      else
        vim.cmd("highlight QuickScopePrimary guifg=#afff5f gui=underline ctermfg=155 cterm=underline")
        vim.cmd("highlight QuickScopeSecondary guifg=#5fffff gui=underline ctermfg=81 cterm=underline")
      end
    end
    set_qs_hl(false)
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("QuickScopeColors", { clear = true }),
      callback = function() set_qs_hl(false) end,
    })
    local ns = vim.api.nvim_create_namespace("qs_underscore_bg")
    local armed = false
    vim.on_key(function(k)
      if vim.fn.mode():find("[nvo]") == nil then return end
      if k == "f" or k == "F" or k == "t" or k == "T" then
        armed = true
        return
      end
      if armed then
        if k == "_" then
          set_qs_hl(true)
          vim.defer_fn(function() set_qs_hl(false) end, 350)
        end
        armed = false
      end
    end, ns)
  end,
}
