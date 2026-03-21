return {
  "olimorris/codecompanion.nvim",
  config = function()
  require("codecompanion").setup({
    strategies = {
      chat = {
        adapter = "openai",
      },
      inline = {
        adapter = "openai",
      },
    },
  })
  end
}
