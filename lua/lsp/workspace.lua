local _M = {}
local log = require('base.log')
local json = require('json')
local util = require("base.util")
require "json.json-beautify"

local workProjectFile = '.nvim_workproject_start.json'

--- Get val of key in the workProject file
---@param key string
---@return string or empty string
function _M.GetValue(key)
	local file = io.open(workProjectFile, "r")
	if file == nil then
		log.warn(workProjectFile .. "not found")
		return ""
	end

	local content = file:read("*all")
	file:close()
	-- Todo use yaml
	return util.GetValTable(json.decode(content), key)
end

--- Overwrite the data of the keys in the workProject file
---@param key string
---@param val string
function _M.OverwriteFile(key, val)
	local old = {}
	local file = io.open(workProjectFile, "r")
	if file ~= nil then
		local content = file:read("*all")
		if content ~= "" then
			old = json.decode(content)
		end
	end

	util.InsertTable(old, key, val)
	file = io.open(workProjectFile, "w")
	if file == nil then
		log.warn("failed to write file,unable to create file")
		return ""
	end

	file:write(json.beautify(old))
	file:close()
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
