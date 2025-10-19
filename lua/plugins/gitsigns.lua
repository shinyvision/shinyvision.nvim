return {
  'lewis6991/gitsigns.nvim',
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Actions
      map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Git: Stage hunk' })
      map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Git: Reset hunk' })

      map('v', '<leader>gs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Git: Stage selected hunks' })

      map('v', '<leader>gr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Git: Reset selected hunks' })

      map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Git: Stage buffer' })
      map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Git: Reset buffer' })
      map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Git: Preview hunk' })
      map('n', '<leader>gi', gitsigns.preview_hunk_inline, { desc = 'Git: Inline preview hunk' })
      map('n', '<leader>gd', gitsigns.diffthis, { desc = 'Git: Diff against index' })

      map('n', '<leader>gD', function()
        gitsigns.diffthis '~'
      end, { desc = 'Git: Diff against last commit' })

      map('n', '<leader>gQ', function()
        gitsigns.setqflist 'all'
      end, { desc = 'Git: Populate quickfix with all hunks' })

      map('n', '<leader>gq', gitsigns.setqflist, { desc = 'Git: Populate quickfix with current file hunks' })

      -- Toggles
      map('n', '<leader>gb', gitsigns.toggle_current_line_blame, { desc = 'Git: Toggle line blame' })
      map('n', '<leader>gw', gitsigns.toggle_word_diff, { desc = 'Git: Toggle word diff' })

      -- Text object
      map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'Git: Select hunk text object' })
    end,
  },
}
