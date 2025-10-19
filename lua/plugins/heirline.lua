return {
  -- ───────────────────────────────────────────────────────────────────────────
  -- STATUS‑LINE
  -- ───────────────────────────────────────────────────────────────────────────
  "rebelot/heirline.nvim",
  event = "BufReadPre",

  -- Explicit dependency — will be installed *and* (because of `lazy=true`)
  -- will auto‑load on first `require("nvim-web-devicons")`.
  dependencies = {
    { "nvim-tree/nvim-web-devicons", lazy = true },
  },

  config = function()
    vim.o.laststatus = 3
    -- OPTIONAL: initialise icons early so they’re coloured
    require("nvim-web-devicons").setup {}

    ---------------------------------------------------------------------------
    -- Heirline configuration (exactly the one we discussed) … shorten here
    ---------------------------------------------------------------------------
    local h = require("heirline")
    local utils, conditions = require("heirline.utils"), require("heirline.conditions")

    local colours = {
      bg = utils.get_highlight("StatusLine").bg,
      fg = utils.get_highlight("StatusLine").fg,
      pink = "#f5c2e7",
      cyan = "#89dceb",
      lavender = "#b4befe",
      surface0 = "#313244",
    }

    -- MODE PILL
    local Mode = {
      static = {
        map = {
          n = "NORMAL",
          no = "O-PENDING",
          i = "INSERT",
          ic = "INSERT",
          v = "VISUAL",
          V = "V-LINE",
          ["\22"] = "V-BLOCK",
          s = "SELECT",
          S = "S-LINE",
          ["\19"] = "S-BLOCK",
          r = "REPLACE",
          R = "REPLACE",
          c = "CMD",
          t = "TERM",
        },
        col = {
          n = colours.pink,
          no = colours.pink,
          i = colours.cyan,
          ic = colours.cyan,
          v = colours.lavender,
          V = colours.lavender,
          ["\22"] = colours.lavender,
          s = colours.lavender,
          S = colours.lavender,
          ["\19"] = colours.lavender,
          r = colours.pink,
          R = colours.pink,
          c = colours.pink,
          t = colours.cyan,
        },
      },
      init = function(self) self.mode = vim.fn.mode(1) end,
      {
        provider = "",
        hl = function(self)
          local m1 = self.mode
          local m = self.col[m1] and m1 or self.mode:sub(1, 1)
          return { fg = self.col[m] or colours.pink }
        end,
      },
      {
        provider = function(self)
          local m1 = self.mode
          local name = self.map[m1] or self.map[self.mode:sub(1, 1)] or m1
          return " " .. tostring(name) .. " "
        end,
        hl = function(self)
          local m1 = self.mode
          local m = self.col[m1] and m1 or self.mode:sub(1, 1)
          return { fg = colours.surface0, bg = self.col[m] or colours.pink, bold = true }
        end,
      },
      {
        provider = "",
        hl = function(self)
          local m1 = self.mode
          local m = self.col[m1] and m1 or self.mode:sub(1, 1)
          return { fg = self.col[m] or colours.pink }
        end,
      },
    }

    -- FILETYPE + ICON
    local FileType = {
      init = function(self)
        local name               = vim.api.nvim_buf_get_name(0)
        local ext                = vim.fn.fnamemodify(name, ":e")
        self.icon, self.icon_col = require("nvim-web-devicons").get_icon_color(name, ext,
          { default = true })
      end,
      {
        provider = function(self) return " " .. (self.icon or "") .. " " end,
        hl = function(self) return { fg = self.icon_col } end
      },
      { provider = function() return vim.bo.filetype:gsub("^%l", string.upper) .. " " end },
      { condition = function() return vim.bo.modified end, provider = "• ", hl = { fg = colours.lavender } },
    }

    local Align = { provider = "%=" }

    -- LSP
    local Lsp = {
      condition = conditions.lsp_attached,
      static = { icon = " " },
      provider = function(self)
        local n = {}
        for _, c in pairs(vim.lsp.get_clients { bufnr = 0 }) do n[#n + 1] = c.name end
        return self.icon .. table.concat(n, ", ") .. " "
      end,
      hl = { fg = colours.lavender },
    }

    local Ruler = { provider = "%3p%%" }

    local prose = require "nvim-prose"
    local WordCount = {
      condition = prose.is_available, -- show only on prose filetypes
      provider = function() return prose.word_count() end,
      hl = { fg = "#9CCFD8", bold = true },
      update = { "BufWritePost", "TextChanged", "InsertLeave" },
    }

    local CurPath = {
      provider = function()
        local filepath = vim.api.nvim_buf_get_name(0)
        local cwd = vim.fn.getcwd()
        return filepath:sub(#cwd + 2)
      end,
      hl = { bold = true },
    }

    h.setup {
      statusline = { Mode, FileType, WordCount, Align, CurPath, Align, Lsp, Ruler },
      opts       = { colors = colours },
    }
  end,
}
