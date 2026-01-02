return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = require("config.gitsigns_config").opts, -- load fancy config
  config = true, -- tells Lazy.nvim to call setup automatically
}

