util.AddNetworkString("OGL_UpdateCVar")

-- Set the new sv_loadingurl link
local function SetLoadingScreen()
    local function BuildLinkArgs()
        local linkArgs = "?"

        for command,_ in pairs(olg_cvars) do
            linkArgs = linkArgs .. command .. "=" .. GetConVar(command):GetString() .. "&"
        end

        return string.Replace(linkArgs, "ogl_", "")
    end

    RunConsoleCommand("sv_loadingurl", "https://3grng17dtqmxmsey95qy0w-on.drv.tw/gmod%20og%20loading%20screen/index4.html" .. BuildLinkArgs())
end

SetLoadingScreen()

-- Receive new cvar values
net.Receive("OGL_UpdateCVar", function(_, ply)
	if ply and ply:IsAdmin() then
		local command = net.ReadString()
		local value = net.ReadString()

		RunConsoleCommand(command, value)

        if timer.Exists("OGL_SetLoadingScreenWait") then
            timer.Destroy("OGL_SetLoadingScreenWait")
        end
    
        timer.Create("OGL_SetLoadingScreenWait", 0.1, 1, function()
            SetLoadingScreen()
        end)
	end
end)

hook.Add("PlayerInitialSpawn", "OGL_FirstSpawn", function(ply)
    for command,_ in pairs(olg_cvars) do
        ply:ConCommand(command .. " " .. GetConVar(command):GetString())
    end
end)