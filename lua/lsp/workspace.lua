local _M = {}
local gohelp = require('base.go_help')
local log = require('base.log')
require "json.json-beautify"

local workProjectFile = '.nvim_workproject_start.yaml'

--- Get val of key in the workProject file
---@param key string
---@return string or empty string
function _M.GetValue(sign, key)
	local data = gohelp.GetStartupConfig(workProjectFile, sign)
	if data ~= nil then
		return data[key]
	end
	return ""
end

--- Overwrite the data of the keys in the workProject file
---@param key string
---@param val string
function _M.OverwriteFile(sign, key, val)
	-- TODO support for modifying other fields
	gohelp.ModifyStartupConfig(workProjectFile, sign, val)
end

--- Verify that the configuration file exists
---@return boolean
function _M.HasWorkspace()
	local file = io.open(workProjectFile, "r")
	if file == nil then
		return false
	end
	file:close()
	return true
end

return _M
