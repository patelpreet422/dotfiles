-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'junegunn/gv.vim',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Project drawer
  {
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require("nvim-tree").setup {
        filters = {
          dotfiles = true,
        },
      }
    end,
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      -- Adds file path completion
      '/hrsh7th/cmp-path'
    },
  },

  {
    -- we use mason to install jdtls but in nvim-lspconfig we disable setting up this server
    -- we use nvim-jdtls because it has more features compared to using nvim-lspconfig, jdtls config
    -- see this https://github.com/neovim/nvim-lspconfig/blob/7eed8b2150192e5ad05e1886fdf133493ddf2928/lua/lspconfig/server_configurations/jdtls.lua#L131C74-L131C116
    --
    "mfussenegger/nvim-jdtls",
    dependencies = { "mfussenegger/nvim-dap" },
    event = "VeryLazy",
    config = function()
      -- Autocmd
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "java" },
        callback = function()
          -- LSP capabilities
          local jdtls = require "jdtls"

          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

          local extendedClientCapabilities = jdtls.extendedClientCapabilities
          extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

          local workspace_dir = require("lspconfig.server_configurations.jdtls").default_config.init_options.workspace
          local launcher = vim.fn.expand(
            "~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.600.v20231106-1826.jar")
          local lombok_jar = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/lombok.jar")

          local os_config = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/config_mac_arm")

          if vim.fn.has("linux") == 1 then
            os_config = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/config_linux")
          end

          local function get_bundles()
            local mason_registry = require "mason-registry"
            local java_debug = mason_registry.get_package "java-debug-adapter"
            local java_test = mason_registry.get_package "java-test"
            local java_debug_path = java_debug:get_install_path()
            local java_test_path = java_test:get_install_path()
            local bundles = {}
            vim.list_extend(bundles,
              vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n"))
            vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n"))
            return bundles
          end

          local bundles = get_bundles()

          local on_buffer_attach_to_jdtls = function(_, bufnr)
            vim.lsp.codelens.refresh()
            jdtls.setup_dap { hotcodereplace = "auto" }
            require("jdtls.dap").setup_dap_main_class_configs()

            local map = function(mode, lhs, rhs, desc)
              if desc then
                desc = desc
              end
              vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
            end

            -- Register keymappings
            local wk = require "which-key"
            local keys = { mode = { "n", "v" }, ["<leader>lj"] = { name = "+Java" } }
            wk.register(keys)

            map("n", "<leader>ljo", jdtls.organize_imports, "Organize Imports")
            map("n", "<leader>ljv", jdtls.extract_variable, "Extract Variable")
            map("n", "<leader>ljc", jdtls.extract_constant, "Extract Constant")
            map("n", "<leader>ljt", jdtls.test_nearest_method, "Test Nearest Method")
            map("n", "<leader>ljT", jdtls.test_class, "Test Class")
            map("n", "<leader>lju", "<cmd>JdtUpdateConfig<cr>", "Update Config")
            map("v", "<leader>ljm", "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>", "Extract Method")


            map('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
            map('n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

            map('n', 'gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
            map('n', 'gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            map('n', 'gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
            map('n', '<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
            map('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
            map('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

            -- See `:help K` for why this keymap
            map('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')
            map('n', '<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

            -- Lesser used LSP functionality
            map('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
            map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            map('n', '<leader>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, '[W]orkspace [L]ist Folders')

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
              vim.lsp.buf.format()
            end, { desc = 'Format current buffer with LSP' })


            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = { "*.java" },
              callback = function()
                local _, _ = pcall(vim.lsp.codelens.refresh)
              end,
            })
          end

          local config = {
            cmd = {
              "java",
              "-Declipse.application=org.eclipse.jdt.ls.core.id1",
              "-Dosgi.bundles.defaultStartLevel=4",
              "-Declipse.product=org.eclipse.jdt.ls.core.product",
              "-Dlog.protocol=true",
              "-Dlog.level=ALL",
              "-Xms1g",
              "--add-modules=ALL-SYSTEM",
              "--add-opens",
              "java.base/java.util=ALL-UNNAMED",
              "--add-opens",
              "java.base/java.lang=ALL-UNNAMED",
              "-javaagent:" .. lombok_jar,
              "-jar",
              launcher,
              "-configuration",
              os_config,
              "-data",
              workspace_dir,
            },
            root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
            capabilities = capabilities,
            on_attach = on_buffer_attach_to_jdtls,
            filetypes = { "java" },
            autostart = true,
            settings = {
              java = {
                autobuild = { enabled = false },
                signatureHelp = { enabled = true },
                contentProvider = { preferred = "fernflower" },
                saveActions = {
                  organizeImports = true,
                },
                sources = {
                  organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                  },
                },
                codeGeneration = {
                  toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                  },
                  hashCodeEquals = {
                    useJava7Objects = true,
                  },
                  useBlocks = true,
                },
                eclipse = {
                  downloadSources = true,
                },
                configuration = {
                  updateBuildConfiguration = "interactive",
                  -- NOTE: Add the available runtimes here
                  -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                  -- runtimes = {
                  --   {
                  --     name = "JavaSE-18",
                  path = vim.fn.expand("~/.sdkman/candidates/java/current"),
                  --   },
                  -- },
                },
                maven = {
                  downloadSources = true,
                },
                implementationsCodeLens = {
                  enabled = true,
                },
                referencesCodeLens = {
                  enabled = true,
                },
                references = {
                  includeDecompiledSources = true,
                },
                inlayHints = {
                  parameterNames = {
                    enabled = "all", -- literals, all, none
                  },
                },
                format = {
                  enabled = true,
                  settings = {
                    url = vim.fn.expand("~/intellij-java-google-style.xml"),
                    profile = "GoogleStyle",
                  },
                }
              },
            },
            init_options = {
              bundles = bundles,
              extendedClientCapabilities = extendedClientCapabilities,
            },
          }

          require("jdtls").start_or_attach(config)
        end
      })
    end,
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    }
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      "nvim-telescope/telescope-file-browser.nvim",
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "java", "javascript", "cpp", "lua", "typescript" })
    end,
    build = ':TSUpdate',
  },

})
