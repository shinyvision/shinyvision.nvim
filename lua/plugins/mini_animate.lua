return {
  "nvim-mini/mini.animate",
  config = function()
    local MiniAnimate = require("mini.animate")
    local mouse_scrolled = false

    for _, dir in ipairs({ "Up", "Down" }) do
      local key = "<ScrollWheel" .. dir .. ">"
      vim.keymap.set({ "", "i" }, key, function()
        mouse_scrolled = true
        return key
      end, { expr = true })
    end

    MiniAnimate.setup({
      cursor = { enable = false },
      resize = { enable = false },
      open = { enable = false },
      close = { enable = false },

      scroll = {
        enable = true,
        timing = MiniAnimate.gen_timing.cubic({ duration = 75, unit = "total" }),
        subscroll = MiniAnimate.gen_subscroll.equal({
          predicate = function(total_scroll)
            -- skip mouse wheel or single-line moves (e.g. j/k)
            if mouse_scrolled or math.abs(total_scroll) == 1 then
              mouse_scrolled = false
              return false
            end
            return true
          end,
        }),
      },
    })
  end,
}
