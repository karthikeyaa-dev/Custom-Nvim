return {
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
      "folke/noice.nvim",
    },

    keys = {
      { "<leader>gg", "<cmd>Neogit kind=floating<cr>", desc = "󰊢 Neogit" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "󰜘 Commit" },
      { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "󰇚 Pull" },
      { "<leader>gP", "<cmd>Neogit push<cr>", desc = "󰇠 Push" },
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "󰕚 Diffview" },
    },

    opts = {
      kind = "floating",
      auto_refresh = true,
      disable_commit_confirmation = true,

      signs_style = "icons",
      signs = {
        section = { "", "" },
        item    = { "󰜴", "󰜴" },
        hunk    = { "󰍶", "󰍴" },
      },

      integrations = {
        diffview = true,
        telescope = true,
      },

      popup = {
        kind = "floating",
        border = "rounded",
        transparency = 15,
        padding = 1,
        minwidth = 95,
        minheight = 30,
        maxwidth = 140,
        maxheight = 45,
      },

      commit_popup = {
        kind = "floating",
        border = "rounded",
      },

      sections = {
        untracked = {
          folded = false,
          title = "󰞋  Untracked",
        },
        unstaged = {
          folded = false,
          title = "󰄱  Unstaged",
        },
        staged = {
          folded = false,
          title = "󰐗  Staged",
        },
        stashes = {
          folded = true,
          title = "󰀿  Stashes",
        },
        recent = {
          folded = true,
          title = "󰋚  Recent Commits",
        },
      },

      hints = {
        border = "rounded",
        position = "top",
      },
    },

    config = function(_, opts)
      local neogit = require("neogit")
      neogit.setup(opts)

      -- ✨ Elegant Noice Notifications
      local function notify(msg, icon)
        vim.schedule(function()
          require("noice").notify(
            string.format("%s %s", icon, msg),
            "info",
            { title = "Neogit" }
          )
        end)
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "NeogitCommitDone",
        callback = function() notify("Commit successful", "󰜘") end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "NeogitPushComplete",
        callback = function() notify("Push completed", "󰇠") end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "NeogitPullComplete",
        callback = function() notify("Pull completed", "󰇚") end,
      })

      -- 🎨 Refined Highlights (Dark Theme Friendly)
      vim.cmd([[
        highlight NeogitSectionTitle guifg=#7aa2f7 gui=bold
        highlight NeogitItemFile guifg=#9ece6a
        highlight NeogitHunkHeader guifg=#bb9af7 gui=bold
        highlight NeogitHunkHeaderHighlight guibg=#292e42
        highlight NeogitDiffAdd guifg=#9ece6a
        highlight NeogitDiffDelete guifg=#f7768e

        highlight NormalFloat guibg=#1a1b26
        highlight FloatBorder guifg=#7aa2f7 guibg=#1a1b26
        highlight NeogitPopupSectionTitle guifg=#e0af68 gui=bold
        highlight NeogitHint guifg=#565f89 gui=italic
      ]])
    end,
  },
}

