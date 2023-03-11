local util = require("base.util")
local packer = require('packer')

packer.use('ravenxrz/DAPInstall.nvim')
packer.use('mfussenegger/nvim-dap')

local dap = require('dap')
function CloseDebug()
	require 'dap'.close()
	require 'dapui'.close({})
	require 'nvim-dap-virtual-text'.disable()
end

util.keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>")
util.keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<CR>")
util.keymap("n", "<leader>ds", "<cmd>lua CloseDebug()<CR>")
util.keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<CR>")
util.keymap("n", "<leader>dlb", "<cmd>lua require'dap'.list_breakpoints()<CR>")
util.keymap("n", "<leader>dcb", "<cmd>lua require'dap'.clear_breakpoints()<CR>")
util.keymap("n", "<F5>", "<cmd>lua require'dap'.step_over()<CR>")
util.keymap("n", "<F6>", "<cmd>lua require'dap'.step_into()<CR>")
util.keymap("n", "<F7>", "<cmd>lua require'dap'.step_out()<CR>")
util.keymap("n", "<leader>dg", "<cmd>lua require'dap'.run_to_cursor()<CR>")
util.keymap("n", "<leader>re", "<cmd>lua require'dap'.repl.toggle()<CR>")
util.keymap("n", "<leader>du", "<cmd>lua require'dapui'.open({reset=true})")

dap.adapters.go = {
	type = 'server',
	port = '${port}',
	executable = {
		command = 'dlv',
		args = { 'dap', '-l', '127.0.0.1:${port}' },
	}
}


dap.set_log_level('TRACE')
dap.configurations.go = {
	{
		type = 'go';
		name = 'Debug';
		request = 'launch';
		-- showLog = true;
		program = "${file}";
	},
	{
		type = 'go';
		name = 'Debug-args';
		request = 'launch';
		-- showLog = true;
		program = "${file}";
		args = function()
			local args_string = vim.fn.input('Arguments: ')
			return vim.split(args_string, " +")
		end;
	},

	{
		type = 'go';
		name = 'workspace-args';
		request = 'launch';
		-- showLog = true;
		program = "${workspaceFolder}";
		-- dlvToolPath = vim.fn.exepath('dlv');  -- Adjust to where delve is installed
		args = function()
			local args_string = vim.fn.input('Arguments: ')
			-- return vim.split(args_string, " +")
			return util.splitArgs(args_string)
		end;
	},
	{
		type = 'delve';
		name = 'remote-default';
		request = 'launch';
		mode = "debug";
		program = function()
			return vim.fn.input('Program: ')
		end;
		outputMode = 'remote';
		substitutePath = {
			{
				from = "/Users/toad/work";
				to = "/root";
			}
		},
		args = function()
			local args_string = vim.fn.input('arguments: ')
			-- return vim.split(args_string, " +")
			return util.splitArgs(args_string)
		end
	},

	{
		type = 'delve';
		name = 'remote';
		request = 'launch';
		mode = "debug";
		program = function()
			return vim.fn.input('Program: ')
		end;
		outputMode = 'remote';
		substitutePath = {
			function()
				local from_to = vim.split(vim.fn.input('localWorkspace/remoteWorkspace:'), " +")
				return {
					from = from_to[1];
					to = from_to[2];
				}
			end;
		},
		args = function()
			local args_string = vim.fn.input('Arguments: ')
			-- return vim.split(args_string, " +")
			return util.splitArgs(args_string)
		end
	},
	{
		type = 'delve';
		name = 'remote-test';
		request = 'launch';
		mode = "debug";
		showLog = true;
		program = "${file}";
		outputMode = 'remote';
	}
}


-- BUG: Get console output is not supported.
-- https://github.com/go-delve/delve/pull/3253
dap.adapters.delve = function(cb, config)
	local host = vim.fn.input('host:')
	local port = vim.fn.input('port:')
	if (host == "") then
		host = "0.0.0.0"
	end

	if (port == "") then
		port = "38697"
	end
	cb({
		type = 'server',
		host = host,
		port = port,
	})
end


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
packer.use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
util.keymap('n', "<leader>k", "<cmd>lua require'dapui'.eval()<CR>")

local dapui = require("dapui")

dap.listeners.before.initialize["dapui_config"] = function()
	dapui.open({ reset = true })
	util.cmd("DapVirtualTextEnable")
end

dap.listeners.after.event_initialized["dapui_config"] = function()

end

dap.listeners.after.event_terminated["dapui_config"] = function()
	util.cmd("DapVirtualTextDisable")
end
dap.listeners.after.event_exited["dapui_config"] = function()
	dapui.close({})
	util.cmd("NvimTreeRefresh")
	util.cmd("DapVirtualTextDisable")
end

dapui.setup()

