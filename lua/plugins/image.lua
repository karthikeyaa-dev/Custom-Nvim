return {
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    opts = {
      backend = "kitty",
      kitty_method = "normal", -- use "tmux" if you use tmux
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
        },
      },
      window_overlap_clear_enabled = true,
    },
  },
}
