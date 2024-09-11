-- lazy.nvim spec
local M = {
  "nvim-neorg/neorg",
  ft = "norg",
  dependencies = {
    "vhyrro/luarocks.nvim",
    -- "nvim-treesitter/nvim-treesitter",
    -- "nvim-treesitter/nvim-treesitter-textobjects",
    -- "nvim-cmp",
    "nvim-lua/plenary.nvim",
  },
  -- build = ":Neorg sync-parsers", -- and delete this line.
  cmd = "Neorg",
}
local modules = {
  ["core.defaults"] = {},
  ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
  ["core.integrations.nvim-cmp"] = {},
  ["core.concealer"] = { config = { icon_preset = "diamond" } },
  ["core.keybinds"] = {
    -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
    config = {
      default_keybinds = true,
      neorg_leader = "<Leader><Leader>",
    },
  },
  ["core.dirman"] = {
    config = {
      workspaces = {
        Notes = "~/Notes/neorg/notes",
        Work = "~/Notes/neorg/work",
        ToDos = "~/Notes/neorg/todo",
      },
      default_workspace = "Notes",
    }
  },
}
M.opts = {
  load = modules,
}
vim.g.maplocalleader = ';'
return M
