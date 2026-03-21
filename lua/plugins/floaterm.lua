local util = require("config.util")

return {
  "voldikss/vim-floaterm",
  lazy = false,
  config = function()
    util.setVimCommand({
      "nnoremap   <silent>   <localleader>ft    :FloatermNew<CR>",
      "tnoremap   <silent>   <localleader>ft    <C-\\><C-n>:FloatermNew<CR>",
      "nnoremap   <silent>   <F8>    :FloatermKill<CR>",
      "tnoremap   <silent>   <F8>    <C-\\><C-n>:FloatermKill<CR>",
      "nnoremap   <silent>   <F9>    :FloatermPrev<CR>",
      "tnoremap   <silent>   <F9>    <C-\\><C-n>:FloatermPrev<CR>",
      "nnoremap   <silent>   <F10>    :FloatermNext<CR>",
      "tnoremap   <silent>   <F10>    <C-\\><C-n>:FloatermNext<CR>",
      "nnoremap   <silent>   <F12>   :FloatermToggle<CR>",
      "tnoremap   <silent>   <F12>   <C-\\><C-n>:FloatermToggle<CR>",
    })
    util.keymap("", "<c-q>", function()
      util.cmd("FloatermKill !")
      util.cmd("wqa")
    end)
  end,
}
