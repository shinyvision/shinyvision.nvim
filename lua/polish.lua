vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format { async = true, lsp_format = "fallback", range = range }
end, { range = true })

vim.api.nvim_set_keymap(
  "n",
  "<leader>m",
  ":lua require('harpoon.mark').add_file()<CR>",
  { noremap = true, desc = "Add current file to Harpoon" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>fm",
  ":lua require('harpoon.ui').toggle_quick_menu()<CR>",
  { noremap = true, desc = "Show a list of Harpoon marks" }
)
vim.api.nvim_set_keymap(
  "n",
  "<C-e>",
  ":lua require('harpoon.ui').toggle_quick_menu()<CR>",
  { noremap = true, desc = "Show a list of Harpoon marks" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>.",
  ":lua require('harpoon.ui').nav_next()<CR>",
  { noremap = true, desc = "Go to next Harpoon mark" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>,",
  ":lua require('harpoon.ui').nav_prev()<CR>",
  { noremap = true, desc = "Go to previous Harpoon mark" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>1",
  ":lua require('harpoon.ui').nav_file(1)<CR>",
  { noremap = true, desc = "Harpoon mark 1" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>2",
  ":lua require('harpoon.ui').nav_file(2)<CR>",
  { noremap = true, desc = "Harpoon mark 2" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>3",
  ":lua require('harpoon.ui').nav_file(3)<CR>",
  { noremap = true, desc = "Harpoon mark 3" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>4",
  ":lua require('harpoon.ui').nav_file(4)<CR>",
  { noremap = true, desc = "Harpoon mark 4" }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>5",
  ":lua require('harpoon.ui').nav_file(5)<CR>",
  { noremap = true, desc = "Harpoon mark 5" }
)
local Terminal = require("toggleterm.terminal").Terminal
local ncspot = Terminal:new { cmd = "ncspot", hidden = true, direction = "float" }

-- always re‑use terminal #1
local term_id = 1

-- size=15 is optional; pick what you like for the horizontal split
vim.keymap.set({ "n" }, "<leader>th",
  string.format("<Cmd>%dToggleTerm size=15 direction=horizontal<CR>", term_id),
  { silent = true, noremap = true })

vim.keymap.set({ "n" }, "<leader>tf",
  string.format("<Cmd>%dToggleTerm direction=float<CR>", term_id),
  { silent = true, noremap = true })

vim.keymap.set("n", "<leader>td", function() require("dbee").toggle() end, { desc = "Toggle dbee" })

vim.keymap.set({ 'n', 't' }, "<C-'>", '<Cmd>ToggleTerm<CR>', { noremap = true, silent = true })


-- Normal/visual
vim.keymap.set({ 'n', 'v' }, '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-l>', '<C-w>l', { silent = true })


vim.keymap.set('n', '\\', '<Cmd>split<CR>', { silent = true })
vim.keymap.set('n', '|', '<Cmd>vsplit<CR>', { silent = true })

local aug = vim.api.nvim_create_augroup('ToggleTermForceT', { clear = true })

vim.api.nvim_create_autocmd({ 'TermOpen', 'BufWinEnter', 'TermEnter' }, {
  group = aug,
  pattern = 'term://*toggleterm#*',
  callback = function()
    vim.schedule(function()
      if vim.fn.mode() ~= 't' then vim.cmd('startinsert!') end
    end)
  end,
})

local function tnav(key)
  return string.format(
    [[<Cmd>stopinsert | wincmd %s<CR>]],
    key
  )
end

vim.keymap.set('t', '<C-h>', tnav('h'), { silent = true })
vim.keymap.set('t', '<C-j>', tnav('j'), { silent = true })
vim.keymap.set('t', '<C-k>', tnav('k'), { silent = true })
vim.keymap.set('t', '<C-l>', tnav('l'), { silent = true })

vim.api.nvim_create_autocmd('TermOpen', {
  group    = aug,
  pattern  = 'term://*toggleterm#*',
  callback = function(args)
    vim.keymap.set('t', '<Esc>', '<Nop>', { buffer = args.buf, noremap = true, silent = true })
    vim.keymap.set('t', '<C-\\><C-n>', '<Nop>', { buffer = args.buf, noremap = true, silent = true })
  end,
})

function _ncspot_toggle() ncspot:toggle() end

vim.api.nvim_set_keymap("n", "<leader>ts", "<cmd>lua _ncspot_toggle()<CR>", { noremap = true, desc = "SPOTIFY" })
vim.api.nvim_set_keymap("v", "<leader>p", 'P', { noremap = true, desc = "Paste no yank" })

require("mini.ai").setup {
  custom_textobjects = {
    v = { "()%s*()$[%w_]+()%s*()" },
    d = require('mini.ai').gen_spec.treesitter(
      { a = { '@conditional.outer', '@loop.outer' },
        i = { '@conditional.inner', '@loop.inner' } },
      { n_lines = 300 }
    ),
  },
}

local builtin = require "telescope.builtin"

local function workspace_symbols()
  builtin.lsp_dynamic_workspace_symbols {
    prompt_title = "Workspace Symbols",
    debounce = 120,
    on_input_filter_cb = function(prompt)
      if #prompt < 2 then return { prompt = prompt, updated = false } end
      return { prompt = prompt }
    end,
  }
end

vim.keymap.set("n", "<leader>fq", workspace_symbols, { desc = "Workspace symbols" })

-- Proper case preservation function
local function preserve_case(match, replacement)
  if match == match:upper() and match ~= match:lower() and #match > 1 then
    -- All uppercase -> make replacement all uppercase
    return replacement:upper()
  elseif match:match "^%u" then
    -- First letter uppercase -> make replacement first letter uppercase, keep rest as-is
    return replacement:sub(1, 1):upper() .. replacement:sub(2)
  else
    -- All lowercase or other cases -> keep replacement as-is
    return replacement
  end
end

_G.preserve_case = preserve_case

-- Function to clear redo buffer by making a minimal change
local function clear_redo_buffer()
  -- Save current position
  local pos = vim.api.nvim_win_get_cursor(0)

  -- Make a minimal change to clear the redo buffer
  -- We'll add and immediately remove a character at the end of the buffer
  local last_line = vim.api.nvim_buf_line_count(0)
  local last_line_content = vim.api.nvim_buf_get_lines(0, last_line - 1, last_line, false)[1]

  -- Add a space and immediately remove it
  vim.api.nvim_buf_set_lines(0, last_line - 1, last_line, false, { last_line_content .. " " })
  vim.api.nvim_buf_set_lines(0, last_line - 1, last_line, false, { last_line_content })

  -- Restore cursor position
  vim.api.nvim_win_set_cursor(0, pos)
end

vim.keymap.set("v", "<leader>sp", function()
  local old = vim.fn.input "Replace: "
  if old == "" then return end

  local new = vim.fn.input "With: "
  if new == "" then return end

  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

  vim.schedule(function()
    local escaped_old = vim.fn.escape(old, "/\\")
    local escaped_new = new:gsub("'", "''")

    -- Always clear redo buffer first, then do the substitute
    clear_redo_buffer()

    vim.cmd "normal! gv"
    vim.cmd "undojoin"
    vim.cmd(string.format([[:'<,'>s/\c%s/\=v:lua.preserve_case(submatch(0), '%s')/g]], escaped_old,
      escaped_new))
  end)
end, { desc = "Substitute with case preservation" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local file_type = vim.bo.filetype
    if not client then return end

    if client.name == "html" and file_type == "templ" then
      client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
    end
  end,
})

local objects = {
  { " ", desc = "whitespace" },
  { '"', desc = '" string' },
  { "'", desc = "' string" },
  { "?", desc = "user prompt" },
  { "_", desc = "underscore" },
  { "`", desc = "` string" },
  { "a", desc = "argument" },
  { "b", desc = ")]} brackets" },
  { "c", desc = "class" },
  { "f", desc = "function" },
  { "q", desc = "quote `\"'" },
  { "v", desc = "PHP $variable" },
  { "t", desc = "tag" },
}

---@type wk.Spec[]
local ret = { mode = { "o", "x" } }
---@type table<string, string>
local mappings = vim.tbl_extend("force", {}, {
  around = "a",
  inside = "i",
  around_next = "an",
  inside_next = "in",
  around_last = "al",
  inside_last = "il",
}, {})
mappings.goto_left = nil
mappings.goto_right = nil

for name, prefix in pairs(mappings) do
  name = name:gsub("^around_", ""):gsub("^inside_", "")
  ret[#ret + 1] = { prefix, group = name }
  for _, obj in ipairs(objects) do
    local desc = obj.desc
    if prefix:sub(1, 1) == "i" then desc = desc:gsub(" with ws", "") end
    ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
  end
end
require("which-key").add(ret, { notify = false })

-- Normal mode
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', { silent = true })
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', { silent = true })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { silent = true })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { silent = true })

-- Insert mode (use <Esc> to temporarily leave insert mode)
vim.keymap.set('i', '<C-Up>', '<Esc>:resize -2<CR>gi', { silent = true })
vim.keymap.set('i', '<C-Down>', '<Esc>:resize +2<CR>gi', { silent = true })
vim.keymap.set('i', '<C-Left>', '<Esc>:vertical resize -2<CR>gi', { silent = true })
vim.keymap.set('i', '<C-Right>', '<Esc>:vertical resize +2<CR>gi', { silent = true })

vim.keymap.set('n', '<leader>cb', ':bd<CR>', { desc = 'Close current buffer' })
vim.keymap.set("n", "<leader>cq", "<cmd>copen<CR>", {
  noremap = true,
  silent = true,
  desc = "Reopen last quickfix list",
})
vim.keymap.set('n', '<leader>bc', ':%bd|e#|bd#<CR>', { desc = 'Close all buffers except current' })

require("image").setup({
  backend = "kitty",
  processor = "magick_rock",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      only_render_image_at_cursor_mode = "popup",
      floating_windows = false,
      filetypes = { "markdown", "vimwiki" },
    },
    neorg = {
      enabled = true,
      filetypes = { "norg" },
    },
    typst = {
      enabled = true,
      filetypes = { "typst" },
    },
    html = {
      enabled = false,
    },
    css = {
      enabled = false,
    },
  },
  max_width = nil,
  max_height = nil,
  max_width_window_percentage = nil,
  max_height_window_percentage = 50,
  window_overlap_clear_enabled = false,                                               -- toggles images when windows are overlapped
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
  editor_only_render_when_focused = false,                                            -- auto show/hide images when the editor gains/looses focus
  tmux_show_only_in_active_window = false,                                            -- auto show/hide images in the correct Tmux window (needs visual-activity off)
  hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
})

vim.keymap.set("n", "<leader>o", function()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local pos = vim.api.nvim_win_get_cursor(win)
  local row, col = pos[1], pos[2]
  local count = vim.v.count1
  local blanks = {}
  for _ = 1, count do
    table.insert(blanks, "")
  end
  vim.api.nvim_buf_set_lines(buf, row, row, true, blanks)
  vim.api.nvim_win_set_cursor(win, { row, col })
end, { desc = "Insert blank line below" })

vim.keymap.set("n", "<leader>O", function()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local pos = vim.api.nvim_win_get_cursor(win)
  local row, col = pos[1], pos[2]
  local count = vim.v.count1
  local blanks = {}
  for _ = 1, count do
    table.insert(blanks, "")
  end
  vim.api.nvim_buf_set_lines(buf, row - 1, row - 1, true, blanks)
  vim.api.nvim_win_set_cursor(win, { row + count, col })
end, { desc = "Insert blank line above" })

vim.api.nvim_set_hl(0, "Visual", { bg = "#3c3836", fg = "NONE" })

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "Visual", { bg = "#3c3836", fg = "NONE" })
  end,
})

vim.keymap.set('i', '<C-y>', '<C-r>+', {
  noremap = true,
  silent  = true,
  buffer  = true,
  desc    = 'Paste system clipboard',
})

vim.keymap.set('n', '<leader>y%', function()
  vim.fn.setreg('+', vim.fn.expand('%'))
end, { desc = 'Yank file path' })
