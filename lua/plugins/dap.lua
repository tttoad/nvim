return {
	{ 'ravenxrz/DAPInstall.nvim' },
	{ 'mfussenegger/nvim-dap' },
	{
		'theHamsta/nvim-dap-virtual-text',
		opt = {
			enabled = true, -- enable this plugin (the default)
			enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
			highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
			highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
			show_stop_reason = true, -- show stop reason when stopped for exceptions
			commented = false, -- prefix virtual text with comment string
			only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
			all_references = false, -- show virtual text on all all references of the variable (not only definitions)
			filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)

		},
	},
	{
		"rcarriga/nvim-dap-ui",
		tag = 'v2.6.0', -- https://github.com/rcarriga/nvim-dap-ui/issues/371
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
	},
	{ "jbyuki/one-small-step-for-vimkind" }
}
