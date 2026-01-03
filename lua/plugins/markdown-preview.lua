return {
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",                   -- lazy-load for markdown files only
    build = "cd app && npm install",   -- install Node.js dependencies
    config = function()
      -- Automatically start preview when opening a Markdown file
      vim.g.mkdp_auto_start = 1
      vim.g.mkdp_auto_close = 0        -- keep preview open when closing buffer
      vim.g.mkdp_browser = "firefox"   -- always open preview in Firefox

      -- Keybindings for convenience
      local opts = { noremap = true, silent = true }

      -- Toggle preview
      vim.api.nvim_set_keymap("n", "<leader>mp", ":MarkdownPreviewToggle<CR>", opts)
      -- Open preview manually
      vim.api.nvim_set_keymap("n", "<leader>mo", ":MarkdownPreview<CR>", opts)
      -- Stop preview
      vim.api.nvim_set_keymap("n", "<leader>mc", ":MarkdownPreviewStop<CR>", opts)
    end,
  },
}

