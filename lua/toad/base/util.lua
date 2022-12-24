local _M = {}

function _M.cmd(cmdStr)
	vim.api.nvim_command(cmdStr)
end

local function split(str, reps)
	local resultStrList = {}
	_ = string.gsub(str, '[^' .. reps .. ']+', function(w)
		table.insert(resultStrList, w)
	end)
	return resultStrList
end

function _M.keymap(model, key, val)
	vim.keymap.set(model, key, val)
end

function _M.setVimKeyMap(keyMap)
	for _, val in pairs(keyMap) do
		local args = split(val, " ")
		local model = string.sub(args[1], 1, 1)

		if (model == 'm') then
			model = ''
		end

		_M.keymap(model, args[2], args[3])
	end
end

function _M.setVimCommand(cmds)
	for _, c in pairs(cmds) do
		_M.cmd(c)
	end
end

return _M
