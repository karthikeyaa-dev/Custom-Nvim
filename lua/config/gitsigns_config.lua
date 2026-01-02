-- =============================
-- 1️⃣ Define beautiful highlights
-- =============================
vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#9ece6a", bold = true })
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#7aa2f7", bold = true })
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#f7768e", bold = true })

vim.api.nvim_set_hl(0, "GitSignsAddNr", { link = "GitSignsAdd" })
vim.api.nvim_set_hl(0, "GitSignsChangeNr", { link = "GitSignsChange" })
vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { link = "GitSignsDelete" })

vim.api.nvim_set_hl(0, "GitSignsAddLn", { link = "GitSignsAdd" })
vim.api.nvim_set_hl(0, "GitSignsChangeLn", { link = "GitSignsChange" })
vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { link = "GitSignsDelete" })

-- =============================
-- 2️⃣ Plugin options
-- =============================
local M = {}

M.opts = {
  -- Normal signs
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },

  -- Staged signs
  signs_staged = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signs_staged_enable = true,

  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = true, -- inline word diff

  watch_gitdir = { follow_files = true },
  attach_to_untracked = true,

  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 400,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = "🖋 <author>, <author_time:%R> • <summary>",

  update_debounce = 100,
  max_file_length = 100000,

  preview_config = {
    border = "rounded",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },

  -- =============================
  -- 3️⃣ Keymaps
  -- =============================
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gs.next_hunk()
      end
    end)

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gs.prev_hunk()
      end
    end)

    -- Actions
    map("n", "<leader>hs", gs.stage_hunk)
    map("n", "<leader>hr", gs.reset_hunk)
    map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
    map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
    map("n", "<leader>hS", gs.stage_buffer)
    map("n", "<leader>hR", gs.reset_buffer)
    map("n", "<leader>hp", gs.preview_hunk)
    map("n", "<leader>hi", gs.preview_hunk_inline)
    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end)
    map("n", "<leader>hd", gs.diffthis)
    map("n", "<leader>hD", function() gs.diffthis("~") end)
    map("n", "<leader>hQ", function() gs.setqflist("all") end)
    map("n", "<leader>hq", gs.setqflist)

    -- Toggles
    map("n", "<leader>tb", gs.toggle_current_line_blame)
    map("n", "<leader>tw", gs.toggle_word_diff)

    -- Text object
    map({ "o", "x" }, "ih", gs.select_hunk)
  end,
}

return M

