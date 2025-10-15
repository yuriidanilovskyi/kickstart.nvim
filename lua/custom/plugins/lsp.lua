return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      -- Ensure mason-tool-installer installs cspell
      require('mason-tool-installer').setup({
        ensure_installed = {
          'cspell',
        },
      })
      -- Setup default LSP keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('custom-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Default LSP navigation mappings
          map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
          map('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
          map('gt', vim.lsp.buf.type_definition, '[G]oto [T]ype Definition')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
          
          -- Diagnostic keymaps
          map('[d', vim.diagnostic.goto_prev, 'Go to previous [D]iagnostic message')
          map(']d', vim.diagnostic.goto_next, 'Go to next [D]iagnostic message')
          map('<leader>e', vim.diagnostic.open_float, 'Show diagnostic [E]rror messages')
          map('<leader>q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')
        end,
      })

      -- Configure diagnostics
      vim.diagnostic.config {
        virtual_text = {
          severity = nil, -- Show all severities
          source = 'if_many',
          spacing = 2,
          prefix = '●', -- Could be '■', '▎', 'x'
        },
        float = { 
          border = 'rounded',
          source = 'if_many',
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      }

      -- Configure LSP servers
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Add custom cspell-lsp server configuration
      vim.lsp.config.cspell = {
        cmd = { 'cspell-lsp', '--stdio' },
        filetypes = { 'c', 'cpp', 'lua', 'python', 'javascript', 'typescript', 'markdown', 'text', 'json', 'yaml', 'html', 'css' },
        root_markers = { '.git' },
        single_file_support = true,
        settings = {
          cspell = {
            enabledLanguageIds = { 'c', 'cpp', 'lua', 'python', 'javascript', 'typescript', 'markdown', 'text', 'json', 'yaml', 'html', 'css' },
          },
        },
      }

      local servers = {
        clangd = {
          cmd = {
            'clangd',
            '--background-index',
            '--header-insertion=never',
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
            '--compile-commands-dir=.',
            '--pch-storage=memory',
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
          filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace',
              },
            },
          },
        },
        cspell = {
          filetypes = { 'c', 'cpp', 'lua', 'python', 'javascript', 'typescript', 'markdown', 'text', 'json', 'yaml', 'html', 'css' },
          settings = {
            cspell = {
              enabledLanguageIds = { 'c', 'cpp', 'lua', 'python', 'javascript', 'typescript', 'markdown', 'text', 'json', 'yaml', 'html', 'css' },
            },
          },
        },
      }

      -- Setup each server
      for server_name, config in pairs(servers) do
        config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
        vim.lsp.enable(server_name, config)
      end
    end,
  },
}
