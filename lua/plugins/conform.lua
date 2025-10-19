return {
  'stevearc/conform.nvim',
  lazy = true,
  event = { 'BufWritePre', 'BufNewFile' },
  opts = {
    formatters_by_ft = {
      php = { 'php-cs-fixer' },
      twig = { 'ludtwig' },
    },
    formatters = {
      ['php-cs-fixer'] = {
        command = 'php-cs-fixer',
        env = {
          PHP_CS_FIXER_IGNORE_ENV = true,
        },
        args = {
          'fix',
          '$FILENAME',
        },
        stdin = false,
      },
      ['ludtwig'] = {
        command = 'ludtwig',
        args = {
          '-c',
          '~/.config/ludtwig/ludtwig-config.toml',
          '-f',
          '$FILENAME',
        },
        stdin = false,
      },
    },
    notify_on_error = true,
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
  },
}
