return {
  {
    "r-pletnev/pdfreader.nvim",

    -- Load when commands are called (CRITICAL)
    cmd = {
      "PdfOpen",
      "PdfNext",
      "PdfPrev",
      "PdfBookmarks",
      "PdfToc",
    },

    dependencies = {
      "folke/snacks.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },

    opts = {},

    keys = {
      { "<leader>bo", "<cmd>PdfOpen<CR>", desc = "Open PDF book" },
      { "<leader>bn", "<cmd>PdfNext<CR>", desc = "Next PDF page" },
      { "<leader>bp", "<cmd>PdfPrev<CR>", desc = "Previous PDF page" },
      { "<leader>bb", "<cmd>PdfBookmarks<CR>", desc = "PDF bookmarks" },
      { "<leader>bf", "<cmd>PdfToc<CR>", desc = "PDF table of contents" },
    },
  },
}


