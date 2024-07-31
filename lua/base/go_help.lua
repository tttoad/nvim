local _M = {}
local log = require('base.log')
local json = require('json')
require "json.json-beautify"

function _M.GetModuleModDir(path)
	local ok, data = _M.ExecHelp("mod-path", "-path=" .. path)
	if ok then
		return json.decode(data)["path"]
	end
	log.err(data)
end

function _M.StartDebugDocker(projectPath)
	local args = {}
	args["project_path"] = projectPath
	local ok, data = _M.ExecHelp("debug-docker", "start -json=" .. json._encode_string(json.encode(args)))
	if ok then
		return json.decode(data)["port"]
	end
	log.err(data)
end

function _M.RemoveDebugDocker(projectPath)
	local args = {}
	args["project_path"] = projectPath
	local ok, data = _M.ExecHelp("debug-docker", "stop -json=" .. json._encode_string(json.encode(args)))
	if ok then
		return "ok"
	end
	log.err(data)
end

function _M.GetStartupConfig(filePath, startup)
	local ok, data = _M.ExecHelp("yaml-edit", "read  -f=\"" .. filePath .. "\" -p=\"" .. startup .. "\"")
	if ok then
		return json.decode(data)
	end
	log.err(data)
	return {}
end

function _M.ModifyStartupConfig(filePath, startup, val)
	local ok, data = _M.ExecHelp("yaml-edit",
		"modify  -f=\"" .. filePath .. "\" -p=\"" .. startup .. "\" -args=\"" .. val .. "\"")
	if ok then
		return "ok"
	end
	log.err(data)
end

function _M.ExecHelp(action, args)
	local res = io.popen('nvimhelp ' .. action .. ' ' .. args)
	log.err('nvimhelp ' .. action .. ' ' .. args)
	if res ~= nil then
		local rea = res:read("*a")
		local resJson = json.decode(rea)
		if resJson["code"] ~= 200 then
			return false, resJson["message"]
		else
			return true, resJson["data"]
		end
		return
	end
end

return _M
