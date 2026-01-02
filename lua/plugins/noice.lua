return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  config = function()
    local noice_config = require("config.noice_configuration")  -- load config from separate file
    require("noice").setup(noice_config)
  end,
}

