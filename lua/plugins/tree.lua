local util = require("config.util")

-- nvim-tree

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    util.keymap("", "<F2>", "<cmd> NvimTreeToggle<cr>")
    util.keymap("", "<localleader>af", "<cmd> NvimTreeFindFile<cr>")
    util.keymap("n", "<localleader>mn", require("nvim-tree.api").marks.navigate.next)
    util.keymap("n", "<localleader>mp", require("nvim-tree.api").marks.navigate.prev)
    util.keymap("n", "<localleader>ms", require("nvim-tree.api").marks.navigate.select)
    local function print_node_path()
      local api = require("nvim-tree.api")
      local node = api.tree.get_node_under_cursor()
      print(node.absolute_path)
    end

    -- on_attach
    vim.keymap.set("n", "<C-P>", print_node_path)

    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end -- default mappings api.config.mappings.default_on_attach(bufnr)

      api.config.mappings.default_on_attach(bufnr)
      local function marksTaggle()
        api.marks.toggle()
        vim.cmd("+1")
      end
      -- custom mappings
      vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
      vim.keymap.set("n", "<space>", marksTaggle, opts("Toggle Bookmark"))
      vim.keymap.set("n", "m", ":+10 <cr>", opts("Next 10 rows"))
    end

    require("nvim-tree").setup({
      on_attach = my_on_attach,
      renderer = {
        group_empty = false,
        icons = {
          glyphs = {
            folder = {
              arrow_closed = " ",
              arrow_open = " ",
            },
          },
        },
      },
      git = {
        enable = true,
        ignore = false,
        show_on_dirs = true,
        timeout = 400,
      },
      filters = {
        dotfiles = true,
      },
    })
  end,
}
