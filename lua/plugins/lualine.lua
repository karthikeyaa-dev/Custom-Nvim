
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("config.lualine_cosmicink") -- load your external config file
  end,
}

