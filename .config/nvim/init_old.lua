local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = {
    current_line = true
  }
--  virtual_text = {
--    prefix = "■",
--  }
})

require("lazy").setup({
  spec = {
    -- Catpuccin theme
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      opts = {
        transparent_background = true,
        float = {
          transparent = true;
        }
      }
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
        ensure_installed = { "lua_ls" },
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
        require("lualine").setup()
      end,
    },
    {
      "mfussenegger/nvim-dap",
    },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
      },
    }
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

vim.cmd.colorscheme "catppuccin"
vim.opt.number = true
