return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VimEnter',
  opts = {
    options = {
      mode = "buffers", -- set to "tabs" to only show tabpages instead
      numbers = "none",
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      left_mouse_command = "buffer %d",
      middle_mouse_command = nil,
      indicator = {
        icon = '▎',
        style = 'icon',
      },
      buffer_close_icon = '󰅖',
      modified_icon = '●',
      close_icon = '',
      left_trunc_marker = '',
      right_trunc_marker = '',
      max_name_length = 18,
      max_prefix_length = 15,
      truncate_names = true,
      tab_size = 18,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      offsets = {
        {
          filetype = "neo-tree",
          text = "File Explorer",
          text_align = "left",
          separator = true
        }
      },
      color_icons = true,
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_tab_indicators = true,
      show_duplicate_prefix = true,
      persist_buffer_sort = true,
      separator_style = "slant",
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      hover = {
        enabled = true,
        delay = 200,
        reveal = {'close'}
      },
      sort_by = 'insert_after_current',
    },
  },
  config = function(_, opts)
    require('bufferline').setup(opts)
    
    -- Buffer navigation keymaps
    vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<cr>', { desc = 'Previous buffer' })
    vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
    vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', { desc = 'Next buffer' })
    vim.keymap.set('n', '<leader>bp', '<cmd>BufferLinePick<cr>', { desc = '[B]uffer [P]ick' })
    vim.keymap.set('n', '<leader>bc', '<cmd>BufferLinePickClose<cr>', { desc = '[B]uffer [C]lose pick' })
    vim.keymap.set('n', '<leader>bl', '<cmd>BufferLineCloseLeft<cr>', { desc = '[B]uffer close [L]eft' })
    vim.keymap.set('n', '<leader>br', '<cmd>BufferLineCloseRight<cr>', { desc = '[B]uffer close [R]ight' })
    vim.keymap.set('n', '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', { desc = '[B]uffer close [O]thers' })
  end,
}