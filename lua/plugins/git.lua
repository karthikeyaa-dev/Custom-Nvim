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
      -- Git Operations
      { "<leader>gg", "<cmd>Neogit kind=floating<cr>", desc = "󰊢 Neogit" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "󰜘 Commit" },
      { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "󰇚 Pull" },
      { "<leader>gP", "<cmd>Neogit push<cr>", desc = "󰇠 Push" },
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "󰕚 Diffview" },
      
      -- Telescope Git Views (Note: gl is now used by gitgraph)
      { "<leader>gC", function() require("telescope.builtin").git_commits() end, desc = "󰜦 Browse Commits" },
      { "<leader>gb", function() require("telescope.builtin").git_branches() end, desc = "󰘬 Browse Branches" },
      { "<leader>gs", function() require("telescope.builtin").git_status() end, desc = "󰄬 Browse Status" },
      { "<leader>gS", function() require("telescope.builtin").git_stash() end, desc = "󰀿 Browse Stashes" },
      
      -- Additional useful mappings
      { "<leader>gf", function() require("telescope.builtin").git_bcommits() end, desc = "󰜦 File History (Blame)" },
      { "<leader>gt", function() require("telescope.builtin").git_tags() end, desc = "󰀬 Browse Tags" },
    },

    opts = {
      kind = "floating",
      auto_refresh = true,
      disable_commit_confirmation = true,
      disable_builtin_notifications = true,

      -- 🎨 Enhanced Visual Elements
      signs_style = "icons",
      signs = {
        section = { "", "" },
        item    = { "󰜴", "󰜴" },
        hunk    = { "󰍶", "󰍴" },
      },

      -- 🔗 Integrations
      integrations = {
        diffview = true,
        telescope = true,
      },

      -- 🪟 Floating Window Configuration
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

      -- 📁 Section Configuration
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

      -- 🌟 Enhanced Telescope Git Commits (using gC instead of gl)
      local function enhanced_git_commits()
        require("telescope.builtin").git_commits({
          previewer = require("telescope.previewers").new_termopen_previewer({
            get_command = function(entry)
              return { "git", "show", "--stat", "--pretty=format:%B", entry.value }
            end,
          }),
          layout_config = {
            width = 0.9,
            height = 0.8,
            preview_cutoff = 1,
            horizontal = {
              preview_width = 0.6,
            },
          },
          mappings = {
            i = {
              ["<C-d>"] = require("telescope.actions").preview_scrolling_down,
              ["<C-u>"] = require("telescope.actions").preview_scrolling_up,
              ["<C-f>"] = require("telescope.actions").preview_scrolling_down,
              ["<C-b>"] = require("telescope.actions").preview_scrolling_up,
              
              -- Enter opens commit in floating window
              ["<CR>"] = function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                
                if selection and selection.value then
                  local commit_hash = selection.value
                  local buf = vim.api.nvim_create_buf(false, true)
                  local width = math.floor(vim.o.columns * 0.8)
                  local height = math.floor(vim.o.lines * 0.8)
                  local row = math.floor((vim.o.lines - height) / 2)
                  local col = math.floor((vim.o.columns - width) / 2)
                  
                  local win = vim.api.nvim_open_win(buf, true, {
                    relative = "editor",
                    width = width,
                    height = height,
                    row = row,
                    col = col,
                    style = "minimal",
                    border = "rounded",
                  })
                  
                  vim.fn.termopen(string.format("git show --stat --patch --color=always %s", commit_hash))
                  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
                  vim.cmd("startinsert")
                end
              end,
              
              -- Ctrl+Enter opens in Diffview
              ["<C-CR>"] = function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                
                if selection and selection.value then
                  vim.cmd(string.format("DiffviewOpen %s", selection.value))
                end
              end,
            },
            n = {
              ["<C-d>"] = require("telescope.actions").preview_scrolling_down,
              ["<C-u>"] = require("telescope.actions").preview_scrolling_up,
              
              -- Enter opens in Diffview
              ["<CR>"] = function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                
                if selection and selection.value then
                  vim.cmd(string.format("DiffviewOpen %s", selection.value))
                end
              end,
              
              -- Ctrl+Enter opens in floating window
              ["<C-CR>"] = function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                
                if selection and selection.value then
                  local commit_hash = selection.value
                  local buf = vim.api.nvim_create_buf(false, true)
                  local width = math.floor(vim.o.columns * 0.8)
                  local height = math.floor(vim.o.lines * 0.8)
                  local row = math.floor((vim.o.lines - height) / 2)
                  local col = math.floor((vim.o.columns - width) / 2)
                  
                  local win = vim.api.nvim_open_win(buf, true, {
                    relative = "editor",
                    width = width,
                    height = height,
                    row = row,
                    col = col,
                    style = "minimal",
                    border = "rounded",
                  })
                  
                  vim.fn.termopen(string.format("git show --stat --patch --color=always %s", commit_hash))
                  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
                  vim.cmd("startinsert")
                end
              end,
            },
          },
        })
      end

      -- Update the keymap to use enhanced version with gC
      vim.keymap.set("n", "<leader>gC", enhanced_git_commits, { desc = "󰜦 Enhanced Commits" })

      -- 📊 Enhanced Git Status Picker
      local function enhanced_git_status()
        require("telescope.builtin").git_status({
          layout_config = {
            width = 0.9,
            height = 0.8,
          },
          previewer = false,
          mappings = {
            i = {
              ["<CR>"] = function(prompt_bufnr)
                local actions = require("telescope.actions")
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                
                if selection then
                  vim.cmd("DiffviewOpen " .. selection.value)
                end
              end,
            },
          },
        })
      end

      -- Update status keymap
      vim.keymap.set("n", "<leader>gs", enhanced_git_status, { desc = "󰄬 Enhanced Status" })

      -- ✨ Elegant Noice Notifications
      local function notify(title, msg, icon)
        vim.schedule(function()
          require("noice").notify({
            title = string.format("%s %s", icon, title),
            message = msg,
            timeout = 3000,
            render = "compact",
          }, "info", {
            title = "Git",
          })
        end)
      end

      -- 🎯 Event Handlers
      vim.api.nvim_create_autocmd("User", {
        pattern = "NeogitCommitDone",
        callback = function(data)
          notify("Commit Successful", "Changes committed successfully", "󰜘")
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "NeogitPushComplete",
        callback = function(data)
          notify("Push Complete", "Changes pushed to remote", "󰇠")
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "NeogitPullComplete",
        callback = function(data)
          notify("Pull Complete", "Updated from remote", "󰇚")
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "NeogitStatusRefreshed",
        callback = function()
          vim.defer_fn(function()
            require("noice").notify({
              message = "Git status refreshed",
              timeout = 1500,
            }, "info")
          end, 100)
        end,
      })

      -- 🎨 Refined Color Scheme
      vim.cmd([[
        " Main UI
        highlight NeogitSectionTitle guifg=#7aa2f7 gui=bold,italic
        highlight NeogitItemFile guifg=#9ece6a gui=none
        highlight NeogitItemAdded guifg=#73daca gui=bold
        highlight NeogitItemModified guifg=#e0af68 gui=bold
        highlight NeogitItemDeleted guifg=#f7768e gui=bold
        
        " Diff Highlights
        highlight NeogitHunkHeader guifg=#bb9af7 gui=bold
        highlight NeogitHunkHeaderHighlight guibg=#24283b
        highlight NeogitDiffAdd guifg=#73daca guibg=#1a1b26
        highlight NeogitDiffDelete guifg=#f7768e guibg=#1a1b26
        highlight NeogitDiffContext guifg=#a9b1d6 guibg=#1a1b26
        
        " Floating Windows
        highlight NormalFloat guibg=#16161e
        highlight FloatBorder guifg=#7aa2f7 guibg=#16161e
        highlight NeogitPopupSectionTitle guifg=#e0af68 gui=bold
        
        " Branch and Status
        highlight NeogitBranch guifg=#ff9e64 gui=bold
        highlight NeogitRemote guifg=#7aa2f7 gui=italic
        
        " Telescope Integration
        highlight TelescopeBorder guifg=#7aa2f7
        highlight TelescopeSelection guibg=#292e42 gui=bold
        highlight TelescopeSelectionCaret guifg=#bb9af7
        
        " Commit Viewer Highlights
        highlight GitCommitHash guifg=#bb9af7 gui=bold
        highlight GitCommitAuthor guifg=#7aa2f7
        highlight GitCommitDate guifg=#e0af68
        highlight GitCommitMessage guifg=#c0caf5
      ]])

      -- 🌈 Utility Functions
      local M = {}

      -- Set keymaps for commit viewing from within Neogit
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "NeogitStatus",
        callback = function()
          vim.keymap.set("n", "<leader>gv", function()
            local line = vim.fn.getline(".")
            local commit_hash = string.match(line, "([%a%d]+)%s+")
            if commit_hash then
              local buf = vim.api.nvim_create_buf(false, true)
              local width = math.floor(vim.o.columns * 0.8)
              local height = math.floor(vim.o.lines * 0.8)
              local row = math.floor((vim.o.lines - height) / 2)
              local col = math.floor((vim.o.columns - width) / 2)
              
              local win = vim.api.nvim_open_win(buf, true, {
                relative = "editor",
                width = width,
                height = height,
                row = row,
                col = col,
                style = "minimal",
                border = "rounded",
              })
              
              vim.fn.termopen(string.format("git show --stat --patch --color=always %s", commit_hash))
              vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
              vim.cmd("startinsert")
            end
          end, { buffer = true, desc = "View Commit Details" })
        end,
      })
    end,
  },
  
  -- GitGraph plugin - Enhanced Visual Git History with beautiful symbols
  {
    "isakbm/gitgraph.nvim",
    dependencies = { "sindrets/diffview.nvim" },
    opts = {
      git_cmd = "git",
      
      -- 🎨 Beautiful Kitty branch symbols
      symbols = {
        merge_commit = '',
        commit = '',
        merge_commit_end = '',
        commit_end = '',
        
        -- Advanced symbols for beautiful graph lines
        GVER = '',  -- Vertical line
        GHOR = '',  -- Horizontal line
        GCLD = '',  -- Corner left down
        GCRD = '╭',  -- Corner right down
        GCLU = '',  -- Corner left up
        GCRU = '',  -- Corner right up
        GLRU = '',  -- Line right up
        GLRD = '',  -- Line right down
        GLUD = '',  -- Line up down
        GRUD = '',  -- Right up down
        GFORKU = '', -- Fork up
        GFORKD = '', -- Fork down
        GRUDCD = '', -- Right up down corner down
        GRUDCU = '', -- Right up down corner up
        GLUDCD = '', -- Left up down corner down
        GLUDCU = '', -- Left up down corner up
        GLRDCL = '', -- Line right down corner left
        GLRDCR = '', -- Line right down corner right
        GLRUCL = '', -- Line right up corner left
        GLRUCR = '', -- Line right up corner right
      },
      
      format = {
        timestamp = '%H:%M:%S %d-%m-%Y',
        fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
      },
      
      -- 🔗 Integrate with Diffview.nvim
      hooks = {
        -- Check diff of a single commit with Diffview
        on_select_commit = function(commit)
          vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!')
        end,
        -- Check diff from commit a -> commit b
        on_select_range_commit = function(from, to)
          vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
        end,
      },
    },
    
    keys = {
      {
        "<leader>gl",
        function()
          require('gitgraph').draw({}, { all = true, max_count = 100 })
        end,
        desc = "GitGraph - Visual Git History",
      },
      {
        "<leader>gL",
        function()
          require('gitgraph').draw({}, { all = true, max_count = 5000 })
        end,
        desc = "GitGraph - Full History",
      },
    },
    
    config = function(_, opts)
      require('gitgraph').setup(opts)
      
      -- Additional keymaps for GitGraph
      vim.keymap.set('n', '<leader>gG', function()
        require('gitgraph').draw({}, { max_count = 50 })
      end, { desc = "GitGraph - Recent Commits" })
      
      -- 🎨 Custom Highlights for GitGraph
      vim.cmd([[
        " Commit Information
        highlight GitGraphHash guifg=#bb9af7 gui=bold
        highlight GitGraphTimestamp guifg=#565f89 gui=italic
        highlight GitGraphAuthor guifg=#7aa2f7
        highlight GitGraphBranchName guifg=#ff9e64 gui=bold
        highlight GitGraphBranchTag guifg=#e0af68
        highlight GitGraphBranchMsg guifg=#c0caf5
        
        " Beautiful Branch Colors
        highlight GitGraphBranch1 guifg=#7aa2f7  " Blue
        highlight GitGraphBranch2 guifg=#9ece6a  " Green
        highlight GitGraphBranch3 guifg=#e0af68  " Yellow
        highlight GitGraphBranch4 guifg=#f7768e  " Red
        highlight GitGraphBranch5 guifg=#bb9af7  " Purple
        
        " Graph Symbols
        highlight GitGraphSymbol guifg=#565f89
        highlight GitGraphMergeCommit guifg=#ff9e64 gui=bold
        highlight GitGraphRegularCommit guifg=#7aa2f7
      ]])
      
      -- 🔧 Enhanced GitGraph Buffer Settings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "gitgraph",
        callback = function()
          -- Enable line numbers
          vim.opt_local.number = true
          vim.opt_local.relativenumber = true
          
          -- Custom keymaps in GitGraph buffer
          vim.keymap.set('n', '<CR>', function()
            local line = vim.fn.getline('.')
            local commit_hash = string.match(line, '([%a%d]+)%s+')
            if commit_hash then
              vim.cmd('DiffviewOpen ' .. commit_hash .. '^!')
            end
          end, { buffer = true, desc = "View Commit Diff" })
          
          vim.keymap.set('n', 'o', function()
            local line = vim.fn.getline('.')
            local commit_hash = string.match(line, '([%a%d]+)%s+')
            if commit_hash then
              -- Open commit in floating window
              local buf = vim.api.nvim_create_buf(false, true)
              local width = math.floor(vim.o.columns * 0.8)
              local height = math.floor(vim.o.lines * 0.8)
              local row = math.floor((vim.o.lines - height) / 2)
              local col = math.floor((vim.o.columns - width) / 2)
              
              local win = vim.api.nvim_open_win(buf, true, {
                relative = "editor",
                width = width,
                height = height,
                row = row,
                col = col,
                style = "minimal",
                border = "rounded",
              })
              
              vim.fn.termopen(string.format("git show --stat --patch --color=always %s", commit_hash))
              vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
              vim.cmd("startinsert")
            end
          end, { buffer = true, desc = "Open Commit Details" })
          
          vim.keymap.set('v', '<CR>', function()
            local start_line = vim.fn.line('v')
            local end_line = vim.fn.line('.')
            
            -- Get commit hashes from selected lines
            local start_hash = string.match(vim.fn.getline(start_line), '([%a%d]+)%s+')
            local end_hash = string.match(vim.fn.getline(end_line), '([%a%d]+)%s+')
            
            if start_hash and end_hash then
              vim.cmd('DiffviewOpen ' .. start_hash .. '~1..' .. end_hash)
            end
          end, { buffer = true, desc = "View Range Diff" })
          
          vim.keymap.set('n', 'r', function()
            require('gitgraph').redraw()
          end, { buffer = true, desc = "Refresh Graph" })
          
          vim.keymap.set('n', 'q', '<cmd>q<cr>', { buffer = true, desc = "Close Graph" })
        end,
      })
    end,
  },
}
