return {
  -- Neogit
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true,
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      current_line_blame = true,
    },
  },

  -- Diffview
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose" },
  },

  -- Merge conflicts
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    config = true,
  },
}

