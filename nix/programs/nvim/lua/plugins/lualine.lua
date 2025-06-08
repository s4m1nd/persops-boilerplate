return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = " "
    else
      vim.o.laststatus = 0
    end
  end,
  config = function()
    vim.o.laststatus = vim.g.lualine_laststatus

    -- Define icons (fallback if LazyVim icons don't exist)
    local icons = {
      diagnostics = {
        Error = " ",
        Warn = " ",
        Info = " ",
        Hint = " ",
      },
      git = {
        added = " ",
        modified = " ",
        removed = " ",
      },
    }

    -- Try to use LazyVim icons if available
    if LazyVim and LazyVim.config and LazyVim.config.icons then
      icons = LazyVim.config.icons
    end

    require("lualine").setup({
      options = {
        theme = "auto",
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        -- Square separators instead of angle brackets
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "█", right = "█" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          -- Root directory (fallback if LazyVim function doesn't exist)
          {
            function()
              if LazyVim and LazyVim.lualine and LazyVim.lualine.root_dir then
                return LazyVim.lualine.root_dir()()
              else
                return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
              end
            end,
            icon = " ",
          },
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          {
            -- Pretty path (fallback if LazyVim function doesn't exist)
            function()
              if LazyVim and LazyVim.lualine and LazyVim.lualine.pretty_path then
                return LazyVim.lualine.pretty_path()()
              else
                local path = vim.fn.expand("%:~:.")
                if path == "" then
                  return "[No Name]"
                end
                return path
              end
            end,
          },
        },
        lualine_x = {
          -- Profiler status (only if Snacks is available)
          {
            function()
              if Snacks and Snacks.profiler and Snacks.profiler.status then
                return Snacks.profiler.status()()
              end
              return ""
            end,
            cond = function()
              return Snacks and Snacks.profiler and Snacks.profiler.status
            end,
          },
          -- Noice command status
          {
            function()
              if package.loaded["noice"] then
                return require("noice").api.status.command.get()
              end
              return ""
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.command.has()
            end,
            color = { fg = "#7aa2f7" }, -- fallback color
          },
          -- Noice mode status
          {
            function()
              if package.loaded["noice"] then
                return require("noice").api.status.mode.get()
              end
              return ""
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
            color = { fg = "#bb9af7" }, -- fallback color
          },
          -- DAP status
          {
            function()
              if package.loaded["dap"] then
                return "  " .. require("dap").status()
              end
              return ""
            end,
            cond = function()
              return package.loaded["dap"] and require("dap").status() ~= ""
            end,
            color = { fg = "#f7768e" }, -- fallback color
          },
          -- Lazy updates
          {
            function()
              if package.loaded["lazy"] then
                return require("lazy.status").updates()
              end
              return ""
            end,
            cond = function()
              return package.loaded["lazy"] and require("lazy.status").has_updates()
            end,
            color = { fg = "#e0af68" }, -- fallback color
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          -- Removed the clock - empty section
        },
      },
      extensions = { "neo-tree", "lazy", "fzf" },
    })
  end,
}
