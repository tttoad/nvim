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

function _M.splitArgs(args)
	local nextIndex = 0
	local result = {}

	for i = 1, #args do
		local c = args:sub(i, i)
		if i < nextIndex then
			goto continue
		end

		if c ~= ' ' then
			local find = false
			for j = i, #args do
				local cc = args:sub(j, j)
				if j >= nextIndex then
					if cc == '\"' then
						local ends = args:find("\"", j + 1)
						if ends == nil then
							ends = args:len() - 1
						end

						nextIndex = ends + 1
					else if cc == " " then
							nextIndex = j
							find = true
							break
						end
					end
				end
			end

			if not find then
				nextIndex = args:len() + 1
			end

			if c == "\"" then
				table.insert(result, args:sub(i + 1, nextIndex - 2))
			else
				table.insert(result, args:sub(i, nextIndex - 1))
			end

			goto continue
		end
		::continue::
	end

	return result
end

function _M.test()
	print("test")
end

return _M
