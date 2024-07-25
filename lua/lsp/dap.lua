local util = require("base.util")
local log = require("base.log")
local gohelp = require("base.go_help")
local packer = require('packer')
local workspace = require('lsp.workspace')

packer.use('ravenxrz/DAPInstall.nvim')
packer.use('mfussenegger/nvim-dap')

local dap = require('dap')
function CloseDebug()
	require 'dap'.close()
	require 'dapui'.close({})
	require 'nvim-dap-virtual-text'.disable()
end

local debugWindowsAll = {
	layouts = {
		{
			elements = { {
				id = "scopes",
				size = 0.25
			}, {
				id = "breakpoints",
				size = 0.25
			}, {
				id = "stacks",
				size = 0.25
			}, {
				id = "watches",
				size = 0.25
			} },
			position = "left",
			size = 40
		},
		{
			elements = {
				{
					id = "repl",
					size = 0.5
				},
				{
					id = "console",
					size = 0.5
				}
			},
			position = "bottom",
			size = 10
		}
	},
}

local debugWindowsOnlyConsole = {
	layouts = {
		{
			elements = {
				{
					id = "repl",
					size = 1
				},
			},
			position = "bottom",
			size = 10
		}
	},
}

local debugWindows = ""
function TaggleDebugWindows()
	if debugWindows == "terminal" then
		require 'dapui'.setup(debugWindowsAll)
		require 'dapui'.toggle({ reset = true })
		debugWindows = "all"
	else
		require 'dapui'.setup(debugWindowsOnlyConsole)
		require 'dapui'.toggle({ reset = true })
		debugWindows = "terminal"
	end
end

util.keymap("n", "<leader>db", function() require 'dap'.toggle_breakpoint() end)
util.keymap("n", "<leader>dt", function() require 'dap'.terminate() end)
util.keymap("n", "<leader>ds", function() CloseDebug() end)
util.keymap('n', '<Leader>dl', function() require('dap').run_last() end)
util.keymap("n", "<leader>dc", function() require 'dap'.continue() end)
util.keymap("n", "<leader>dlb", function() require 'dap'.list_breakpoints() end)
util.keymap("n", "<leader>dcb", function() require 'dap'.clear_breakpoints() end)
util.keymap("n", "<F5>", function() require 'dap'.step_over() end)
util.keymap("n", "<F6>", function() require 'dap'.step_into() end)
util.keymap("n", "<F7>", function() require 'dap'.step_out() end)
util.keymap("n", "<leader>dg", function() require 'dap'.run_to_cursor() end)
util.keymap("n", "<leader>re", function() require 'dap'.repl.toggle() end)
util.keymap("n", "<leader>du", function() require 'dapui'.open({ reset = true }) end)
util.keymap("n", "<leader>da", function() TaggleDebugWindows() end)

-- dap.set_log_level('TRACE')

CheckUseDefault = {
	NeedCheck = true,
	UseDefault = false
}

function WorkspaceConfig(key, cb)
	local needCB = true
	if CheckUseDefault.NeedCheck then
		local keys = util.split(key, ".")
		if workspace.HasWorkspace() and workspace.GetValue(keys[1]) ~= "" then
			local input = vim.fn.input("use default last config:")
			if input == "" or input:sub(0) ~= 'n' then
				needCB = false
			end
		end
	else
		needCB = CheckUseDefault.UseDefault
	end
	if needCB then
		local val = cb()
		workspace.OverwriteFile(key, val)
		return val, needCB
	end

	return workspace.GetValue(key), needCB
end

function GetArgsByWorkspace(key)
	CheckUseDefault.NeedCheck = true
	local args, NeedCB = WorkspaceConfig(key .. ".args", function()
		return vim.fn.input('Arguments: ')
	end)
	CheckUseDefault.NeedCheck = false
	CheckUseDefault.UseDefault = NeedCB
	return vim.split(args, " +")
end

function GetExecFileName()
	return util.GetWorkAbsPath() .. "/" .. util.GetFileName()
end

dap.configurations.go = {
	{
		type = 'go',
		name = 'Debug',
		request = 'launch',
		program = "${file}",
	},
	{
		type = 'go',
		name = 'Debug-args',
		request = 'launch',
		program = "${file}",
		args = function()
			return GetArgsByWorkspace('Debug-args-' .. GetExecFileName())
		end,
	},
	{
		type = 'docker',
		name = 'local-docker',
		request = 'launch',
		mode = "debug",
		outputMode = 'remote',
		program = function()
			local fileName = util.GetFileName()
			local workPath = gohelp.GetModuleModDir(fileName)
			return string.gsub(fileName, workPath, "")
		end,
		substitutePath = {
			function()
				local workPath = gohelp.GetModuleModDir(util.GetFileName())
				return {
					from = util.GetDirByPath(workPath),
					to = "/root",
				}
			end,
		},
		args = function()
			return GetArgsByWorkspace("local-docker")
		end
	},
	{
		type = 'go',
		name = 'workspace-args',
		request = 'launch',
		program = "${workspaceFolder}",
		args = function()
			return GetArgsByWorkspace("workspace-args")
		end,
	},
	{
		type = 'delve',
		name = 'remote-default',
		request = 'launch',
		mode = "debug",
		args = function()
			return GetArgsByWorkspace("remote-default")
		end,
		program = function()
			local config = WorkspaceConfig('remote-default.program', function()
				return vim.fn.input('program: ')
			end)
			return config
		end,
		outputMode = 'remote',
		substitutePath = {
			{
				from = "/Users/toad/work",
				to = "/root",
			}
		}
	},
	{
		type = 'delve',
		name = 'remote',
		request = 'launch',
		mode = "debug",
		args = function()
			return GetArgsByWorkspace("remote")
		end,
		program = function()
			local config = WorkspaceConfig('remote.program', function()
				return vim.fn.input('program: ')
			end)
			return config
		end,
		outputMode = 'remote',
		substitutePath = {
			function()
				local config = WorkspaceConfig('remote.substitutePath', function()
					local from_to = vim.split(vim.fn.input('localWorkspace/remoteWorkspace:'), " +")
					return {
						from = from_to[1],
						to = from_to[2],
					}
				end)
				return config
			end,
		},
	},
	{
		type = 'delve-docker',
		name = 'remote-wip',
		request = 'launch',
		mode = "debug",
		outputMode = 'remote',
		substitutePath = {
			function()
				util.GetWorkAbsPath()
			end,
		},
		args = function()
			local args_string = vim.fn.input('Arguments: ')
			return util.splitArgs(args_string)
		end
	},

	{
		type = 'delve',
		name = 'remote-test',
		request = 'launch',
		mode = "debug",
		showLog = true,
		program = "${file}",
		outputMode = 'remote',
		args = function()
			return GetArgsByWorkspace("remote-test-" .. GetExecFileName())
		end,
	},
}

dap.adapters.delve = function(cb)
	local sc = WorkspaceConfig('delve', function()
		local host = vim.fn.input('host:')
		local port = vim.fn.input('port:')
		if (host == "") then
			host = "0.0.0.0"
		end

		if (port == "") then
			port = "38697"
		end
		return {
			host = host,
			port = port,
		}
	end)
	cb({
		type = 'server',
		host = sc["host"],
		port = sc["port"],
	})
end

dap.adapters.docker = function(cb, config)
	local workPath = gohelp.GetModuleModDir(util.GetFileName())
	local port = gohelp.StartDebugDocker(workPath)
	cb({
		type = 'server',
		host = '0.0.0.0',
		port = port,
	})
end

dap.adapters.go = {
	type = 'server',
	port = '${port}',
	executable = {
		command = 'dlv',
		args = { 'dap', '-l', '127.0.0.1:${port}' },
	}
}

packer.use('theHamsta/nvim-dap-virtual-text')
-- nvim-dap-virtual-text
require("nvim-dap-virtual-text").setup({
	enabled = true, -- enable this plugin (the default)
	enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
	highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
	highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
	show_stop_reason = true, -- show stop reason when stopped for exceptions
	commented = false, -- prefix virtual text with comment string
	only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
	all_references = false, -- show virtual text on all all references of the variable (not only definitions)
	filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
})

-- dap-ui
packer.use({
	"rcarriga/nvim-dap-ui",
	tag = 'v2.6.0', -- https://github.com/rcarriga/nvim-dap-ui/issues/371
	requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
})
util.keymap('n', "<leader>k", function() require 'dapui'.eval() end)

local dapui = require("dapui")

dap.listeners.before.initialize["dapui_config"] = function()
	dapui.setup(debugWindowsOnlyConsole)
	dapui.toggle({ reset = true })
	debugWindows = "terminal"
	util.cmd("DapVirtualTextEnable")
end

dap.listeners.after.event_initialized["dapui_config"] = function()

end

dap.listeners.after.event_terminated["dapui_config"] = function()
	util.cmd("DapVirtualTextDisable")
	util.cmd("NvimTreeResize 40")
end

dap.listeners.after.event_exited["dapui_config"] = function()
	dapui.close({})
	util.cmd("DapVirtualTextDisable")
	util.cmd("NvimTreeResize 40")
end

-- lua
packer.use("jbyuki/one-small-step-for-vimkind")
dap.configurations.lua = {
	{
		type = 'nlua',
		request = 'attach',
		name = "Attach to running Neovim instance",
	}
}

dap.adapters.nlua = function(callback, config)
	callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
end
