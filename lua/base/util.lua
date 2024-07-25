local _M = {}
local log = require('base.log')

function _M.cmd(cmdStr)
	vim.api.nvim_command(cmdStr)
end

function _M.split(str, reps)
	local resultStrList = {}
	local size = 0
	_ = string.gsub(str, '[^' .. reps .. ']+', function(w)
		table.insert(resultStrList, w)
		size = size + 1
	end)
	return resultStrList, size
end

function _M.InsertTable(tb, key, val)
	local keys, size = _M.split(key, ".")
	local temp = tb
	for k, v in ipairs(keys) do
		if k == size then
			temp[v] = val
		else
			if temp[v] == nil or type(temp[v]) ~= "table" then
				temp[v] = {}
			end
			temp = temp[v]
		end
	end
end

function _M.GetValTable(tb, key)
	local keys, size = _M.split(key, ".")
	local temp = tb
	for k, v in ipairs(keys) do
		if k == size then
			return temp[v]
		else
			if temp[v] == nil then
				-- log.warn("table " .. key .. " is nil")
				return ""
			end
			if type(temp[v]) ~= "table" then
				log.warn("table " .. key .. " in " .. v .. " is not table")
				return ""
			end
			temp = temp[v]
		end
	end
end

function _M.TrimSpaces(str)
	return string.gsub(str, "^%s*(.-)%s*$", "%1")
end

function _M.keymap(model, key, val)
	vim.keymap.set(model, key, val)
end

function _M.setVimKeyMap(keyMap)
	for _, val in pairs(keyMap) do
		local args = _M.split(val, " ")
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

function _M.sudoExec(cmd, print_output)
	vim.fn.inputsave()
	local password = vim.fn.inputsecret("Password: ")
	vim.fn.inputrestore()
	if not password or #password == 0 then
		log.warn("Invalid password, sudo aborted")
		return false
	end
	local out = vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
	if vim.v.shell_error ~= 0 then
		print("\r\n")
		log.err(out)
		return false
	end
	if print_output then print("\r\n", out) end
	return true
end

function _M.sudoWrite(tmpfile, filepath)
	if not tmpfile then tmpfile = vim.fn.tempname() end
	if not filepath then filepath = vim.fn.expand("%") end
	if not filepath or #filepath == 0 then
		log.err("E32: No file name")
		return
	end
	-- `bs=1048576` is equivalent to `bs=1M` for GNU dd or `bs=1m` for BSD dd
	-- Both `bs=1M` and `bs=1m` are non-POSIX
	local cmd = string.format("dd if=%s of=%s bs=1048576",
		vim.fn.shellescape(tmpfile),
		vim.fn.shellescape(filepath))
	-- no need to check error as this fails the entire function
	vim.api.nvim_exec(string.format("write! %s", tmpfile), true)
	if _M.sudoExec(cmd) then
		log.info(string.format([[\r\n"%s" written]], filepath))
		vim.cmd("e!")
	end
	vim.fn.delete(tmpfile)
end

--
-- function _M._echo_multiline(msg)
-- 	for _, s in ipairs(vim.fn.split(msg, "\n")) do
-- 		vim.cmd("echom '" .. s:gsub("'", "''") .. "'")
-- 	end
-- end
--
-- function _M.info(msg)
-- 	_M._echo_multiline(msg)
-- 	vim.cmd("echohl None")
-- end
--
-- function _M.warn(msg)
-- 	_M._echo_multiline(msg)
-- 	vim.cmd("echohl None")
-- end
--
-- function _M.err(msg)
-- 	_M._echo_multiline(msg)
-- 	vim.cmd("echohl None")
-- end
--
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
					else
						if cc == " " then
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

function _M.GetWorkAbsPath()
	return vim.fn.getcwd()
end

function _M.GetFilePath()
	return vim.fn.expand("%:p")
end

function _M.GetFileName()
	return vim.fn.expand("%")
end

function _M.GetWorkLastPath()
	local project = ""
	_ = string.gsub(_M.GetWorkAbsPath(), '[^/]+', function(w)
		project = w
	end)
	return project
end

function _M.FormatVar(line, _)
	local arr = _M.split(_M.TrimSpaces(line), " ")
	if #arr == 0 then
		return ""
	end

	local str = arr[1]
	local startIndex, endIndex = string.find(line, str)
	local result = ""
	local pre = false
	if string.find(str, "_") then
		-- to humps
		for i = 1, #str do
			local c = str:sub(i, i)
			if pre then
				result = result .. string.upper(c)
				pre = false
				goto continue
			end
			if c == '_' then
				pre = true
				goto continue
			end
			result = result .. c
			:: continue ::
		end
	else
		local first = str:sub(1, 1)
		if first >= 'a' and first <= 'z' then
			result = string.upper(first) .. str:sub(2)
		else
			for i = 1, #str do
				local c = str:sub(i, i)
				if i == 1 then
					result = result .. string.lower(c)
					goto continue
				end
				if c >= 'A' and c <= 'Z' then
					result = result .. '_' .. string.lower(c)
					goto continue
				end
				result = result .. c
				:: continue ::
			end
		end
	end

	return line:sub(0, startIndex - 1) .. result .. line:sub(endIndex + 1)
end

function _M.GetDirByPath(path)
	return string.match(path, "(.+)/[^/]*")
end

function _M.test()
	print("test")
end

return _M
