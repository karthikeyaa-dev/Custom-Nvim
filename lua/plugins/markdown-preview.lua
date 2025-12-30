return {
  "iamcco/markdown-preview.nvim",
  ft = "markdown",
  build = "cd app && npm install",  -- if you need to install dependencies
  config = function()
    vim.g.mkdp_auto_start = 1  -- optional: auto-start preview on markdown file open
  end
}

