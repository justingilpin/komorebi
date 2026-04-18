require("lazy").setup({

  -- Colorscheme (Gruvbox — matches your NixOS GruvboxAlt theme)
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({ contrast = "hard" })
      vim.cmd("colorscheme gruvbox")
    end,
  },

  -- Statusline (lualine — from your dots)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "gruvbox", globalstatus = true },
      })
    end,
  },

  -- File browser (oil — from your dots)
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({ view_options = { show_hidden = true } })
    end,
  },

  -- File tree (neo-tree — from your dots)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = { { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "neo-tree" } },
  },

  -- Fuzzy finder (telescope — from your dots, uses ripgrep)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end,
  },

  -- Syntax highlighting (treesitter — from your dots)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "javascript", "typescript", "bash", "json", "yaml", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "pyright", "ts_ls" },
        automatic_installation = true,
      })
      local lsp = require("lspconfig")
      lsp.lua_ls.setup({})
      lsp.pyright.setup({})
      lsp.ts_ls.setup({})
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, { name = "luasnip" },
        }, { { name = "buffer" } }),
      })
    end,
  },

  -- Which-key (from your dots)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function() require("which-key").setup({}) end,
  },

  -- Trouble (from your dots)
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("trouble").setup({}) end,
  },

  -- Noice (from your dots)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    config = function()
      require("noice").setup({
        lsp = { override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        }},
        presets = { bottom_search = true, long_message_to_split = true },
      })
    end,
  },

  -- Autopairs (from your dots)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function() require("nvim-autopairs").setup({}) end,
  },

  -- Colorizer (from your dots)
  {
    "norcalli/nvim-colorizer.lua",
    config = function() require("colorizer").setup() end,
  },

  -- Web devicons (from your dots)
  { "nvim-tree/nvim-web-devicons" },

  -- Copilot (from your dots)
  {
    "github/copilot.vim",
    event = "InsertEnter",
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = { add = { text = "+" }, change = { text = "~" } },
      })
    end,
  },

}, {
  -- lazy.nvim options
  ui = { border = "rounded" },
})
