return {
  'luukvbaal/statuscol.nvim',
  dependencies = { 'lewis6991/gitsigns.nvim' }, -- make sure gitsigns is around
  config = function()
    local builtin = require 'statuscol.builtin'

    require('statuscol').setup {
      segments = {
        { text = { builtin.foldfunc, ' ' }, click = 'v:lua.ScFa' },
        { text = { builtin.lnumfunc }, click = 'v:lua.ScLa' },
        {
          sign = { namespace = { 'diagnostic/signs' }, maxwidth = 1, auto = true },
          click = 'v:lua.ScSa',
        },
        {
          sign = { namespace = { 'gitsigns' }, maxwidth = 1, colwidth = 1, auto = true },
          click = 'v:lua.ScSa',
        },
      },
    }
  end,
}
