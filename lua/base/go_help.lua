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

function _M.ExecHelp(action, args)
	local res = io.popen('nvimhelp -r=' .. action .. ' ' .. args)
	if res ~= nil then
		local resJson = json.decode(res:read("*a"))
		if resJson["code"] ~= 200 then
			return false, resJson["message"]
		else
			return true, resJson["data"]
		end
		return
	end
end

return _M
