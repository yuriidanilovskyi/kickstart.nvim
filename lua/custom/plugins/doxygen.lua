return {
  {
    'danymat/neogen',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('neogen').setup {
        enabled = true,
        languages = {
          c = {
            template = {
              annotation_convention = 'doxygen',
            },
          },
          cpp = {
            template = {
              annotation_convention = 'doxygen',
            },
          },
        },
      }

      -- Custom function to detect and generate doxygen comments
      local function generate_doxygen()
        local line = vim.api.nvim_get_current_line()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        
        -- Check for #define
        if line:match('^%s*#define') then
          local comment = {
            '/**',
            ' * @brief ',
            ' */'
          }
          vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, comment)
          vim.api.nvim_win_set_cursor(0, {row + 1, 10}) -- Position cursor after @brief
          return
        end
        
        -- Check for union
        if line:match('union%s+%w+') or line:match('^%s*union') then
          local comment = {
            '/**',
            ' * @brief ',
            ' */'
          }
          vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, comment)
          vim.api.nvim_win_set_cursor(0, {row + 1, 10}) -- Position cursor after @brief
          return
        end
        
        -- Fallback to neogen for other cases
        require('neogen').generate()
      end

      -- Keymap to generate documentation
      vim.keymap.set('n', '<leader>dg', generate_doxygen, { desc = '[D]oxygen [G]enerate documentation' })
    end,
  },
}