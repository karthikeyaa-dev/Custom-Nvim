return {
  {
    "nvzone/typr",
    dependencies = {
      "nvzone/volt",
    },
    cmd = { "Typr", "TyprStats" },
    opts = {},

    keys = {
      {
        "<leader>tt",
        "<cmd>Typr<CR>",
        desc = "Start Typr typing practice",
      },
      {
        "<leader>ts",
        "<cmd>TyprStats<CR>",
        desc = "View Typr stats",
      },
    },
  },
}
