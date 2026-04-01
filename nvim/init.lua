local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.clipboard = "unnamedplus"
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = {
    current_line = true
  }
  -- virtual_text = {
  --   prefix = "■",
  -- }
})

require("lazy").setup({
  spec = {
    -- Pywal16 theme
    {
      'uZer/pywal16.nvim',
      -- for local dev replace with:
      -- dir = '~/your/path/pywal16.nvim',
      config = function()
        vim.cmd.colorscheme("pywal16")
      end,
    },
    -- Treesitter syntax highlighting
	  {
      "nvim-treesitter/nvim-treesitter",
      branch = 'master',
      lazy = false,
      build = ":TSUpdate"
    },
    -- Mason package manager
	  { "mason-org/mason.nvim", opts = {} },
    -- Neovim user-made lsps default configs
    { "neovim/nvim-lspconfig" },
    -- Automatic setup of lsps using mason and nvmi-lspconfig
    {
      "mason-org/mason-lspconfig.nvim",
      opts = {
        ensure_installed = { "lua_ls", "rust_analyzer", "omnisharp", "clangd" },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup{}
          end,
          ["rust_analyzer"] = function()
            require("lspconfig").rust_analyzer.setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
              ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                checkOnSave = { command = "clippy" },
              },
            },
          })
        end,
        }
      },
      dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
      }
    },
    -- Neovim icons for multiple plugins
    { "nvim-tree/nvim-web-devicons" },
    -- nvim-tree -- Plugin to navigate files
    {
      "nvim-tree/nvim-tree.lua",
      opts = {},
      dependencies = { "nvim-tree/nvim-web-devicons" },
      keys = {
        {
          "<leader>e",
          function ()
            vim.cmd("NvimTreeOpen")
          end,
          desc = "Open nvim-tree",
        }
      }
    },
    -- nvim-autopairs -- Plugin to autmomatically pair brackets and other
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true
    },
    -- indent-blankline -- Plugin to display a blankline for better indent
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      ---@module "ibl"
      ---@type ibl.config
      opts = {},
    },
    -- nvim-cmp -- Plugin to implement autocomplete
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
      },
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        cmp.setup({
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = {
            ['<CR>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    if luasnip.expandable() then
                        luasnip.expand()
                    else
                        cmp.confirm({
                            select = true,
                        })
                    end
                else
                    fallback()
                end
            end),

            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
              else
                fallback()
              end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          },
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
          })
        })
      end,
    },
    -- which-key -- Plugin that shows what commands can be executed based on the user input
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {
      },
    },
    -- lualine -- Plugin that shows a statusline at the bottom of the editor
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function ()
        require("lualine").setup({
          options = {
            theme = 'pywal16-nvim',
          },
        })
      end,
    },
    -- Debug Adapter Protocol -- Plugin that allows to debug a program in neovim like an IDE
    {
      "mfussenegger/nvim-dap",
      keys = {
        {
          "<leader>db",
          function ()
            vim.cmd("DapToggleBreakpoint")
          end,
          desc = "Add breakpoint at line",
        },
        {
          "<leader>dr",
          function ()
            vim.cmd("DapContinue")
          end,
          desc = "Start or continue the debugger",
        },
      }
    },
    -- Automatic setup of DAP using mason
    {
      "jay-babu/mason-nvim-dap.nvim",
      event = "VeryLazy",
      dependencies = {
        "mason-org/mason.nvim",
        "mfussenegger/nvim-dap",
      },
      opts = {
        handlers = {},
        ensure_installed = {
          "codelldb",
        },
      },
    },
    -- DAP UI -- Plugin that adds a UI to DAP
    {
      "rcarriga/nvim-dap-ui",
      event = "VeryLazy",
      dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
      },
      config = function ()
        local dap, dapui = require("dap"), require("dapui")
        dap.listeners.before.attach.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
          dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
          dapui.close()
        end
      end,
    },
    -- Plugin which provides commands to comment code easier
    {
      "numToStr/Comment.nvim",
      opts = {

      }
    },
    -- barbar -- Plugin that adds in neovim like an IDE
    {
      "romgrk/barbar.nvim",
      dependencies = {
        'lewis6991/gitsigns.nvim',
        'nvim-tree/nvim-web-devicons',
      },
      init = function () vim.g.barbar_auto_setup = false end,
      opts = {
      }
    },
    -- LazyGit -- Plugin that allows to use LazyGit within neovim
    {
      "kdheepak/lazygit.nvim",
      lazy = true,
      cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile"
      },
      dependencies = {
        "nvim-lua/plenary.nvim"
      },
      keys = {
        {"<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit"}
      }
    },
    -- NoneLs -- Fork of the NullLs plugin which makes management of linters easy
    {
      "nvimtools/none-ls.nvim",
      opts = function(_, opts)
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        opts.on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
              group = augroup,
              buffer = bufnr,
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function ()
                vim.lsp.buf.format({bufnr = bufnr})
              end,
            })
          end
        end
      end,
    },
    {
      "jay-babu/mason-null-ls.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "williamboman/mason.nvim",
        "nvimtools/none-ls.nvim",
      },
      opts = {
        ensure_installed = {
          'clang_format'
        },
        handlers = {

        },
      },
    },
    { -- This plugin
      "Zeioth/compiler.nvim",
      cmd = {"CompilerOpen", "CompilerToggleResults", "CompilerRedo"},
      dependencies = { "stevearc/overseer.nvim", "nvim-telescope/telescope.nvim" },
      opts = {},
      keys = {
        {
          "<leader>c",
          function ()
            vim.cmd("CompilerOpen")
          end,
          desc = "Open compiler",
        }
      }
    },
    { -- The task runner we use
      "stevearc/overseer.nvim",
      commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
      cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
      opts = {
        task_list = {
          direction = "bottom",
          min_height = 25,
          max_height = 25,
          default_detail = 1
        },
      },
    },
    {
        -- see the image.nvim readme for more information about configuring this plugin
        "3rd/image.nvim",
        opts = {
            backend = "kitty", -- whatever backend you would like to use
            max_width = 100,
            max_height = 12,
            max_height_window_percentage = math.huge,
            max_width_window_percentage = math.huge,
            window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        },
    }
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

vim.api.nvim_create_autocmd("Signal", {
    pattern = "SIGUSR1",
    command = "colorscheme pywal16",
})
vim.opt.number = true

