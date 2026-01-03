return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },  -- automatically load for markdown files
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.nvim",         -- needed for icons/padding (optional)
      -- or "nvim-mini/mini.icons"   -- if you use mini.icons standalone
      -- or "nvim-tree/nvim-web-devicons" -- if you prefer web devicons
    },
    opts = {
      -- default config (you can customize below)
      enabled = true,
      render_modes = { "n", "c", "t" },  -- render in normal/command/toggle modes
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle Markdown render" },
      { "<leader>me", "<cmd>RenderMarkdown expand<CR>", desc = "Expand rendered preview" },
      { "<leader>mc", "<cmd>RenderMarkdown contract<CR>", desc = "Contract rendered preview" },
      { "<leader>ml", "<cmd>RenderMarkdown log<CR>", desc = "Markdown render log" },
    },
  },
}
