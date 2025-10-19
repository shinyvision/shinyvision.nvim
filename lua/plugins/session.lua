return {
  "stevearc/resession.nvim",
  config = function()
    local rs = require("resession")
    rs.setup()
    local DIR = "dirsession"

    local function save(dir, opts)
      rs.save(dir, vim.tbl_extend("force", { dir = DIR }, opts or {}))
    end
    local function load(dir)
      rs.load(dir, { dir = DIR, silence_errors = true })
    end

    vim.keymap.set("n", "<leader>S", function() load(vim.fn.getcwd()) end,
      { desc = "Load dir‑session" })
    vim.keymap.set("n", "<leader>s", function() save(vim.fn.getcwd()) end,
      { desc = "Save dir‑session" })

    local function arg_dir()
      if vim.fn.argc(-1) ~= 1 then return nil end
      ---@type string
      local arg = (vim.fn.argv()[1]) -- list → string
      if vim.fn.isdirectory(arg) == 0 then return nil end
      local dir = vim.fs.normalize(vim.fn.fnamemodify(arg, ":p"))
      return dir:gsub("/$", "")
    end

    vim.api.nvim_create_autocmd("VimEnter", {
      nested = true,
      callback = function()
        if vim.g.using_stdin then return end
        local dir = (vim.fn.argc(-1) == 0) and vim.fn.getcwd() or arg_dir()
        if dir then
          vim.fn.chdir(dir)
          load(dir)
        end
      end,
    })

    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function() save(vim.fn.getcwd(), { notify = false }) end,
    })

    vim.api.nvim_create_autocmd("StdinReadPre", {
      callback = function() vim.g.using_stdin = true end,
    })
  end,
}
