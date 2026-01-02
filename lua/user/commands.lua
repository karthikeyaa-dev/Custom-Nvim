-- lua/user/commands.lua
vim.api.nvim_create_user_command("LuaREPL", function()
  require("astrocore").toggle_term_cmd("lua -i", {
    direction = "float",
    float_opts = { border = "rounded" },
  })
end, { desc = "Open Lua REPL" })

vim.keymap.set("n", "<leader>rl", "<cmd>LuaREPL<cr>", { desc = "Lua REPL" })

