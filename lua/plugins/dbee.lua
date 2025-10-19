return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    require("dbee").install()
  end,
  config = function()
    require("dbee").setup {
      sources = {
        require("dbee.sources").MemorySource:new({
          {
            name = "GHS DEV",
            type = "postgres",
            url = "postgres://postgres:postgres@127.0.0.1:5432/ghs_dev?sslmode=disable",
          },
          {
            name = "GHS RELEASE",
            type = "postgres",
            url = "postgres://postgres:postgres@127.0.0.1:5432/ghs_release?sslmode=disable",
          },
          {
            name = "SSH TUNNEL",
            type = "postgres",
            url = "postgres://webdev:W3bd3v@127.0.0.1:5431/sylius?sslmode=disable",
          },
          {
            name = "Huisjes",
            type = "postgres",
            url = "postgres://postgres:postgres@127.0.0.1:5432/huisjes?sslmode=disable",
          },
        }),
        require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS"),
        require("dbee.sources").FileSource:new(vim.fn.stdpath("cache") .. "/dbee/persistence.json"),
      }
    }
  end,
}
