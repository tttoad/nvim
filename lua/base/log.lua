local _log = {}
local json = require('json')
require "json.json-beautify"


function _log._echo_multiline(msg)
	if type(msg) == "table" then
		msg = json.encode(msg)
	end

	for _, s in ipairs(vim.fn.split(msg, "\n")) do
		vim.cmd("echom '" .. s:gsub("'", "''") .. "'")
	end
end

function _log.info(msg)
	_log._echo_multiline(msg)
	vim.cmd("echohl None")
end

function _log.warn(msg)
	_log._echo_multiline(msg)
	vim.cmd("echohl None")
end

function _log.err(msg)
	_log._echo_multiline(msg)
	vim.cmd("echohl None")
end

return _log
