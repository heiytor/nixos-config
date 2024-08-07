{ pkgs, lib, ... }:

{
  programs.neovim = let
    fromGitHub = repo: ref: rev: pkgs.vimUtils.buildVimPlugin {
      name = "${lib.strings.sanitizeDerivationName repo}";
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
        rev = rev;
      };
    };

    typescript-language-server = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
  in {
    enable = true;
    defaultEditor = true;
    package = pkgs.neovim-nightly;
    plugins = (with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
      lsp-zero-nvim
      nvim-lspconfig
      formatter-nvim
      nvim-cmp
      cmp-nvim-lsp
      luasnip
      kanagawa-nvim
      plenary-nvim
      telescope-nvim
      gitsigns-nvim
      nvim-autopairs
      lualine-nvim
      nvim-web-devicons
      comment-nvim
      indent-blankline-nvim
      harpoon
      nvim-colorizer-lua
      rainbow-delimiters-nvim
      todo-comments-nvim
    ]) ++ [
      (fromGitHub "d00h/telescope-any" "master" "0e79dd6131c8a7282899679cd9ffa14e74d2c973")

      # > Colorschemes: 
      (fromGitHub "scottmckendry/cyberdream.nvim" "main" "bb3011a38b94ac4f13c107f5f1b3464c1c03ced1")
      # (fromGitHub "huyvohcmc/atlas.vim" "master" "f254465adbcae565d9cf8c987f5a797c1f9cf922")
      # (fromGitHub "axvr/photon.vim" "master" "32b42c8a12bf9588259b76f3df6807960e0d7386")
      # (fromGitHub "datsfilipe/vesper.nvim" "main" "b26a348293cc6a16941f6429e3a20de58a584170")
    ];
    extraPackages = with pkgs; [
      # TODO: install LSP in flake.nix
      ripgrep       # telescope
      git           # gitsigns
      xclip         # copy to clipboard keybinding
      gopls         # go language server
      rust-analyzer # rust language server
      nixd          # nix language server
      clang-tools   # c languague tools
      ruby-lsp      # ruby lsp
    ];
    extraConfig = ''
      lua << EOF
        -- startup

        vim.g.mapleader = " "

        vim.opt.nu = false
        vim.opt.number = false
        vim.opt.relativenumber = false

        vim.opt.colorcolumn = "0"
        -- For Git commits, the 73rd column is marked as the colorcolumn,
        -- representing the maximum limit for writing.
        vim.cmd[[
          autocmd FileType gitcommit setlocal colorcolumn=73
        ]]

        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.expandtab = true
        -- Nix files only need 2 spaces
        vim.cmd[[
          autocmd FileType nix setlocal tabstop=2 softtabstop=2 shiftwidth=2
        ]]

        vim.opt.smartindent = true
        vim.opt.wrap = false
        vim.opt.swapfile = false
        vim.opt.backup = false
        vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
        vim.opt.undofile = true
        vim.opt.hlsearch = false
        vim.opt.incsearch = true
        vim.opt.termguicolors = true
        vim.opt.scrolloff = 8
        vim.opt.signcolumn = "yes"
        vim.opt.isfname:append("@-@")
        vim.opt.updatetime = 50

        -------------------------------------------
        -------------------------------------------
        ---                Theme                ---
        -------------------------------------------
        -------------------------------------------

        -- vim.cmd("colorscheme atlas")

        -- require('kanagawa').setup({ theme = "dragon" })
        -- vim.cmd("colorscheme kanagawa-dragon")

        require("cyberdream").setup({ theme = { variant = "light" } })
        vim.cmd("colorscheme cyberdream")

        -- [Optional] Disable the background color
        -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

        -------------------------------------------
        -------------------------------------------
        ---            Key map utils            ---
        -------------------------------------------
        -------------------------------------------
        local keymap = {}

        --- Prepends the toggle key to the given key.
        ---@param key string
        keymap.toggle = function(key)
          return "t" .. key
        end

        --- Prepends the leader key to the given key.
        ---@param key string
        keymap.leader = function(key)
          return "<leader>" .. key
        end

        --- Prepends the control modifier to the given key.
        ---@param key string
        keymap.ctrl = function(key)
          return "<C-" .. key .. ">"
        end

        --- Prepends the shift modifier to the given key.
        ---@param key string
        keymap.shift = function(key)
          return "<S" .. key .. ">"
        end

        --- Sets a key.
        ---@param k table
        keymap.map = function(k)
          vim.keymap.set(k.mode, k.lhs, k.rhs, k.opts)
        end

        --- Sets N keys. Optionally, sets default options for each key.
        ---
        ---@param keys table The list of key bindings.
        ---@param opts table Optional table of default options to be applied to each key binding.
        keymap.map_table = function(keys, opts)
          for _, k in ipairs(keys) do
            if opts then
              for o_k, o_v in pairs(opts) do
              	k[o_k] = o_v
              end
            end

            vim.keymap.set(k.mode, k.lhs, k.rhs, k.opts)
          end
        end

        -------------------------------------------
        -------------------------------------------
        ---             Keybindings             ---
        -------------------------------------------
        -------------------------------------------

        local keys = {}

        keys.nop = {
          { mode = "n", lhs = "J", rhs = "<nop>", opts = {} },
          { mode = "n", lhs = "K", rhs = "<nop>", opts = {} },
          { mode = "n", lhs = "Q", rhs = "<nop>", opts = {} },
          { mode = "n", lhs = ";p", rhs = "<nop>", opts = {} },
        }

        keys.std= {
          -- Normal MODE
          {
            mode = "n",
            lhs = keymap.leader("e"),
            rhs = vim.cmd.Ex,
            opts = {
            	desc = "Enter file explorer.",
            },
          },
          {
            mode = "n",
            lhs = "n",
            rhs = "nzzzv",
            opts = {
            	desc = "Keep cursor in the middle when searching",
            },
          },
          {
            mode = "n",
            lhs = "N",
            rhs = "Nzzzv",
            opts = {
            	desc = "Keep cursor in the middle when searching",
            },
          },
          {
            mode = "n",
            lhs = keymap.ctrl("a"),
            rhs = "ggVG",
            opts = {
            	desc = "Select all buffer.",
            },
          },
          {
            mode = "n",
            lhs = keymap.leader("s"),
            rhs = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
            opts = {
            	desc = "Rename all [current word] occurrences in the current buffer",
            },
          },
          {
            mode = "n",
            lhs = keymap.leader("d"),
            rhs = [[:%s///gI<Left><Left><Left><Left>]],
            opts = {
              desc = "Rename all occurrences in the current buffer",
            },
          },
          {
            mode = "n",
            lhs = keymap.toggle("l"),
            rhs = function()
              vim.o.number = not vim.o.number
            end,
            opts = {
              desc = "Toggle line number view.",
            },
          },
          {
            mode = "n",
            lhs = keymap.toggle("c"),
            rhs = function()
              vim.o.colorcolumn = (vim.o.colorcolumn ~= "0") and "0" or "80"
            end,
            opts = {
              desc = "Toggle color column [80] view.",
            },
          },
          -- Visual MODE
          {
            mode = "v",
            lhs = "K",
            rhs = ":m '>-2<cr>gv=gv",
            opts = {
              desc = "Move selected lines to top",
            },
          },
          {
            mode = "v",
            lhs = "J",
            rhs = ":m '>+1<cr>gv=gv",
            opts = {
              desc = "Move selected lines to bottom",
            },
          },
          {
            mode = "v",
            lhs = keymap.leader("y"),
            rhs = [["+y]],
            opts = {
              desc = "Copy to clipboard.",
            },
          },
          -- Select mode
          {
            mode = "x",
            lhs = "p",
            rhs = [["_dP]],
            opts = {
              desc = "As theprimeagen said, greatest remap ever",
            },
          },
        }

        keymap.map_table(keys.nop, {})
        keymap.map_table(keys.std, {})

        -------------------------------------------
        -------------------------------------------
        ---            Plugin config            ---
        -------------------------------------------
        -------------------------------------------

        require("nvim-autopairs").setup()
        require("nvim-treesitter.configs")
        require("treesitter-context")
        require("colorizer").setup()
        require("todo-comments").setup()

        -- Rainbow Delimiters

        local rainbow_delimiters = require("rainbow-delimiters")

        ---@type rainbow_delimiters.config
        vim.g.rainbow_delimiters = {
          strategy = {
            [""] = rainbow_delimiters.strategy["global"],
            vim = rainbow_delimiters.strategy["local"],
          },
          query = {
            [""] = "rainbow-delimiters",
            lua = "rainbow-blocks",
          },
          priority = {
            [""] = 110,
            lua = 210,
          },
          highlight = {
            "RainbowDelimiterRed",
            "RainbowDelimiterYellow",
            "RainbowDelimiterBlue",
            "RainbowDelimiterOrange",
            "RainbowDelimiterGreen",
            "RainbowDelimiterViolet",
            "RainbowDelimiterCyan",
          },
        }

        -- Gitsigns

        require("gitsigns").setup({
          on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local keys = {
              {
              	mode = "n",
              	lhs = keymap.toggle("g"),
              	rhs = gs.toggle_current_line_blame,
              	opts = {
              	  desc = "[Gitsign] Toggle line blame.",
              	},
              },
            }

            keymap.map_table(keys, { buffer = bufnr })
          end,

          current_line_blame_opts = { delay = 10 },
          current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        })

        -- Lualine

        require("lualine").setup({
          options = {
            theme = "auto",
            ignore_focus = {
              "mason",
              "TelescopePrompt",
              "packer",
              "dashboard",
            },
            globalstatus = true,
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
          },
          sections = {
            lualine_a = {
              {
              	"mode",
              	fmt = function(str)
              		return str:sub(1, 3) -- show only three chars
              	end,
              },
            },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = {
              {
              	"filename",
              	path = 1, -- relative path
              },
            },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
          },
        })

        require("Comment").setup({
          mappings = {
            basic = true,
            extra = false,
          },
        })

        -- Indent blankline

        local IblHighlight = {
          "RainbowRed",
          "RainbowYellow",
          "RainbowBlue",
          "RainbowOrange",
          "RainbowGreen",
          "RainbowViolet",
          "RainbowCyan",
        }

        local IblHooks = require("ibl.hooks")
        IblHooks.register(IblHooks.type.HIGHLIGHT_SETUP, function()
          vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
          vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
          vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
          vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
          vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
          vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
          vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
        end)

        vim.g.rainbow_delimiters = { highlight = IblHighlight }
        require("ibl").setup({
          scope = {
            highlight = IblHighlight,
          },
        })

        IblHooks.register(IblHooks.type.SCOPE_HIGHLIGHT, IblHooks.builtin.scope_highlight_from_extmark)

        -- Telescope

        -- keybindings was replaced by telescope-any
        -- {
        --   mode = "n",
        --   lhs = ";f",
        --   rhs = function()
        --     Telescope_Telescope_builtin.find_files({
        --       respect_gitignore = false,
        --       no_ignore = false,
        --       hidden = true,
        --     })
        --   end,
        --   opts = {
        --     desc = "[Telescope] Find files.",
        --   },
        -- },
        -- {
        --   mode = "n",
        --   lhs = ";r",
        --   rhs = function()
        --     Telescope_Telescope_builtin.live_grep({
        --     	respect_gitignore = false,
        --     })
        --   end,
        --   opts = {
        --     desc = "[Telescope] Find files by word.",
        --   },
        -- },
        -- {
        --   mode = "n",
        --   lhs = ";s",
        --   rhs = function()
        --     Telescope_Telescope_builtin.treesitter()
        --   end,
        --   opts = {
        --     desc = "[Telescope] List definitions.",
        --   },
        -- },
        -- {
        --   mode = "n",
        --   lhs = ";g",
        --   rhs = function()
        --     Telescope_Telescope_builtin.git_files({ hidden = true })
        --   end,
        --   opts = {
        --     desc = "[Telescope] List definitions.",
        --   },
        -- },

        local Telescope_builtin = require("telescope.builtin")
        local Telescope_any = require("telescope-any").create_telescope_any({
          pickers = {
            [""]    = Telescope_builtin.current_buffer_fuzzy_find,
            ["g "]  = Telescope_builtin.live_grep,
            ["f "]  = Telescope_builtin.find_files,
            ["b "]  = Telescope_builtin.buffers,
            ["gf "] = Telescope_builtin.git_files,
            ["gc "] = Telescope_builtin.git_commits,
          },
        })

        keys.telescope = {
          {
            mode = "n",
            lhs = "/",
            rhs = Telescope_any,
            opts = {
              desc = "[Telescope] Find any.",
              silent = true,
            },
          },
        }

        keymap.map_table(keys.telescope, {})

        -- Harpoon

        local HarpoonMark = require("harpoon.mark")
        local HarpoonUI = require("harpoon.ui")

        keys.harpoon = {
          {
            mode = "n",
            lhs = keymap.leader("a"),
            rhs = HarpoonMark.add_file,
            opts = {},
          },
          {
            mode = "n",
            lhs = keymap.leader("h"),
            rhs = HarpoonUI.toggle_quick_menu,
            opts = {},
          },
          -- TODO: keymap to close a buffer
          {
            mode = "n",
            lhs = keymap.ctrl("h"),
            rhs = function()
              HarpoonUI.nav_file(1)
            end,
            opts = {},
          },
          {
            mode = "n",
            lhs = keymap.ctrl("j"),
            rhs = function()
              HarpoonUI.nav_file(2)
            end,
            opts = {},
          },
          {
            mode = "n",
            lhs = keymap.ctrl("k"),
            rhs = function()
              HarpoonUI.nav_file(3)
            end,
            opts = {},
          },
          {
            mode = "n",
            lhs = keymap.ctrl("l"),
            rhs = function()
              HarpoonUI.nav_file(4)
            end,
            opts = {},
          },
        }

        keymap.map_table(keys.harpoon, {})

        -- LSP, autocompletions and formatters

        local LSP = require("lsp-zero")
        local LSPconfig = require("lspconfig")

        LSP.on_attach(function(client, bufnr)
          keys = {
            {
              mode = "n",
              lhs = "<F2>",
              rhs = vim.lsp.buf.rename,
              opts = {},
            },
            {
              mode = "n",
              lhs = "gd",
              rhs = vim.lsp.buf.definition,
              opts = {},
            },
            {
              mode = "n",
              lhs = "K",
              rhs = vim.lsp.buf.hover,
              opts = {},
            },
            {
              mode = "n",
              lhs = "<leader>ref",
              rhs = vim.lsp.buf.references,
              opts = {},
            },
            {
              mode = "n",
              lhs = "<leader>ws",
              rhs = vim.lsp.buf.workspace_symbol,
              opts = {},
            },
            {
              mode = "n",
              lhs = "[d",
              rhs = vim.diagnostic.goto_next,
              opts = {},
            },
            {
              mode = "n",
              lhs = "]d",
              rhs = vim.diagnostic.goto_prev,
              opts = {},
            },
          }

          keymap.map_table(keys, { buffer = bufnr, remap = false })
        end)

        -- go language server
        LSPconfig.gopls.setup({
          settings = {
            gopls = {
              gofumpt = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = false,
                constantValues = true,
                parameterNames = true,
                functionTypeParameters = false,
                rangeVariableTypes = false,
              },
            },
          },
        })

        -- rust language server
        LSPconfig.rust_analyzer.setup({
          settings = {
            ["rust-analyzer"] = {
              inlayHints = {
                maxLength = 25,
              },
            },
          },
        })

        -- nix language server
        LSPconfig.nixd.setup({})

        -- c language server
        LSPconfig.clangd.setup({ settings = {} })

        -- ruby language server
        LSPconfig.solargraph.setup({})

        -- typescript language server
        LSPconfig.tsserver.setup({
          cmd = { "${typescript-language-server}", "--stdio" },
          settings = {
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayVariableTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayVariableTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            typescriptreact = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayVariableTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        })

        local CMP = require("cmp")
        CMP.setup({
          sources = {
            { name = "nvim_lsp" },
          },
          mapping = {
            ["<S-Tab>"] = nil,
            ["<Tab>"] = nil,
            ["<Up>"] = CMP.mapping.select_prev_item({behavior = "select"}),
            ["<Down>"] = CMP.mapping.select_next_item({behavior = "select"}),
            ["<Enter>"] = CMP.mapping.confirm({ select = true }),
            ["<Esc>"] = CMP.mapping.abort(),
          },
        })

        require("formatter").setup({
          filetype = {
            go = require("formatter.filetypes").go.gofmt,
            -- ruby = require("formatter.filetypes").ruby.rubocop,
          },
        })

        -- Format on save
        vim.api.nvim_exec(
          [[
              augroup FormatAutogroup
                autocmd!
                autocmd BufWritePost * FormatWriteLock
              augroup END
          ]],
          false
        )

        -- Inlay hints
        -- Automatically enable when entering Insert mode, and disable them upon leaving.
        -- Can be disabled with "<leader>nn" at Normal mode.
        local inlay_hints = {}
        inlay_hints.on_insert = function()
          local valid_filetypes = { "go", "rust", "typescript", "typescriptreact" }
          local use_inlay_hints = true

          vim.api.nvim_create_autocmd({ "InsertEnter" }, {
            callback = function()
              if not use_inlay_hints then
                return
              end

              for _, ft in ipairs(valid_filetypes) do
                if vim.bo.filetype == ft then
                  vim.lsp.inlay_hint.enable(0, true)
                  return
                end
              end
            end,
          })

          vim.api.nvim_create_autocmd({ "InsertLeave" }, {
            callback = function()
              if not use_inlay_hints then
                return
              end

              vim.lsp.inlay_hint.enable(0, false)
            end,
          })

          keymap.map({
            mode = "n",
            lhs = keymap.leader("nn"),
            rhs = function()
              use_inlay_hints = not use_inlay_hints
            end,
            opts = {
            	desc = "Toggle inlay hints",
            },
          })
        end

        inlay_hints.on_insert()
      EOF
    '';
  };
}
