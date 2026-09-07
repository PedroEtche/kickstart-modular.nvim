-- AI code autocompletion
return {
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup {}
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
--
-- Lo que usan Zite y Eze
-- return { -- Github Copilot for lua
--   'zbirenbaum/copilot.lua',
--   cmd = 'Copilot',
--   event = 'InsertEnter',
--   config = function()
--     require('copilot').setup {
--       suggestion = { enabled = true, auto_trigger = true },
--       panel = { enabled = true },
--     }
--   end,
-- }
