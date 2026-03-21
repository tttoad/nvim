local util = require("config.util")
local gohelp = require("config.go_help")

function GoAddTagsPlugin()
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  local source = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
  local flags = vim.fn.inputlist({
    "Select the debugging mode for tags:",
    "(1):json.",
    "(2):gorm.",
    "(3):schema.",
    "(4):yaml.",
    "(5):custom.",
  })

  local tag = ""
  if flags == 2 then
    tag = "gorm"
  elseif flags == 3 then
    tag = "schema"
  elseif flags == 4 then
    tag = "yaml"
  elseif flags == 5 then
    tag = vim.fn.input("args:")
  else
    tag = "json"
  end

  source = string.gsub(string.gsub(source, '"', '\\"'), "`", "\\`")
  vim.api.nvim_buf_set_lines(0, linenr - 1, linenr, false, { gohelp.AddTags(source, tag) })
end

function GoAddTagPlugin()
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  local source = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
  print(source, vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[2])
end

-- util.keymap('', "<F1>", ":GoDocBrowser<CR>")
-- util.keymap('n', "<leader>fill", ":GoFillStruct<CR>")
util.keymap("n", "<leader>tg", GoAddTagsPlugin)
util.keymap("v", "<leader>tc", GoAddTagPlugin)

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver will be automatically installed with mason and loaded with lspconfig
        tsserver = {},
      }, -- you can do any additional lsp server setup here return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
  },
  { import = "lazyvim.plugins.extras.lang.typescript" },
}
