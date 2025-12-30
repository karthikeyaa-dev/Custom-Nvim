return {
  "dhruvasagar/vim-table-mode",
  ft = { "markdown", "text", "csv" },
  config = function()
    vim.g.table_mode_map_prefix = "<leader>t"
  end
}
