local util = require("base.util")
local log = require("base.log")

local _M = {}

function _M.runDebugDocker(tar, source, dlvPath, project)
	-- local exitCode = os.execute("make runDebugGoImage TAR=" ..
	-- tar .. " SOURCE=" .. source .. " DELVE=" .. dlvPath .. " PROJECT=" ..
	-- project)
	local exitCode = os.execute("docker run -v " ..
	tar ..
	":" .. source .. " -v " ..
	dlvPath .. ":/root/delve -w " .. tar .. " -p 38697:38697 -d --name " .. project .. "debug/go:latest .")

	return exitCode
end

function _M.stopDebugDocker(project)
	local exitCode = os.execute("make stopDebugGoImage PROJECT=" .. project)

	if (exitCode ~= 0) then
		log.err("failed to stop go.debug image,exitCode:" .. exitCode)
	end
end

function _M.StartGoDebug()
	local source = util.GetWorkAbsPath()
	local dlvPath = os.getenv("GOROOT") .. "/bin/dlv"
	local project = util.GetWorkLastPath()
	local tar = "/root/" .. project
	local exitCode = _M.runDebugDocker(tar, source, dlvPath, project)

	if (exitCode ~= 0) then
		log.err("failed to run go.debug image,exitCode:" .. exitCode)
	else
		log.info("run success...")
	end
end

function _M.StopGoDebug()
	local exitCode = _M.stopDebugDocker(util.GetWorkLastPath())

	if (exitCode ~= 0) then
		log.err("failed to stop go.debug image,exitCode:" .. exitCode)
	else
		log.info("stop success...")
	end
end

util.keymap("n", "<leader>dri", "<cmd>lua require'docker.docker'.StartGoDebug()<CR>")
util.keymap("n", "<leader>dsi", "<cmd>lua require'docker.docker'.StopGoDebug()<CR>")

return _M
