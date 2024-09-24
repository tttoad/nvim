local util = require("base.util")
local gohelp = require("base.go_help")
local log = require("base.log")

-- TODO: vim-ultest is deprecation.
-- https://github.com/rcarriga/vim-ultest?tab=readme-ov-file#deprecation-warning
-- https://github.com/nvim-neotest/neotest
-- https://github.com/fredrikaverpil/neotest-golang

util.keymap("n", "<leader>tr", "<cmd>UltestSummary<cr>")
util.keymap("n", "<leader>td", "<cmd>UltestDebug<cr>")
util.cmd("let g:ultest_deprecation_notice = 0")

local ultest = require 'ultest'

ultest.setup({
	builders = {
		["go#gotest"] = function(cmds)
			local args = {}
			for i = 3, #cmds - 1, 1 do
				local arg = args[i]
				if vim.startswith(arg, "-") then
					arg = "-test." .. string.sub(arg, 2)
				end
				args[#args + 1] = arg
			end


			local mode = vim.fn.inputlist({
				'Select the debugging mode for unit tests:',
				'(1):single function.',
				'(2):single file.',
				'(3):dir.'
			})

			local program = util.GetDirByPath(util.GetFilePath())
			if (mode == 2) then
				program = util.GetFileName()
			elseif (mode == 3) then
				args[#args + 1] = "-test.v"
			else
				local fn = vim.fn.expand('<cword>')
				local isBench = string.find(fn, "Benchmark")
				args[#args + 1] = "-test.run"
				args[#args + 1] = fn

				if (isBench ~= nil) then
					args[#args + 1] = "-test.bench"
					args[#args + 1] = fn
					args[#args + 1] = "-test.benchmem"
				end
			end

			vim.cmd("redraw")
			mode = vim.fn.inputlist({
				'Select the debugging mode for unit tests:',
				'(1):local mode.',
				'(2):remote mode.',
				'(3):others use local mode.'
			})

			local workPath = gohelp.GetModuleModDir(util.GetFileName())
			if (mode ~= 2) then
				return {
					dap = {
						type = 'go',
						name = 'Debug test',
						request = 'launch',
						mode = 'test',
						program = program,
						args = args,
						dlvCwd = workPath,
					},
					parse_result = function(lines)
						return lines[#lines] == "FAIL" and 1 or 0
					end
				}
			else
				local from = util.GetDirByPath(workPath)
				local to = "/root"
				program = string.gsub(program, from, to)
				workPath = string.gsub(workPath, from, to)
				return {
					dap = {
						type = 'docker',
						name = 'Debug test',
						request = 'launch',
						mode = 'test',
						program = program,
						outputMode = 'remote',
						dlvCwd = workPath,
						substitutePath = {
							function()
								return {
									from = from,
									to = to,
								}
							end,
						},
						args = args,
					},
					parse_result = function(lines)
						return lines[#lines] == "FAIL" and 1 or 0
					end
				}
			end
		end
	}
})
