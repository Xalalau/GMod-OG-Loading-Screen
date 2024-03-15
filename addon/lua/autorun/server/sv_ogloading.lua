util.AddNetworkString("OGL_UpdateCVar")

-- Set the new sv_loadingurl link
local function SetLoadingScreen()
    local command = ogl_svloading .. OGL_BuildLinkArgs()
    local comSize = string.len(command)

    if string.len(command) > 260 then
        local warning = "WARNING! sv_loadingurl is too big! Max size is 260, yours is " .. comSize .. ". Shorten your image links." 
        print(warning)
        PrintMessage(HUD_PRINTTALK, warning)
    else
        RunConsoleCommand("sv_loadingurl", ogl_svloading .. OGL_BuildLinkArgs())

        -- keep the command saved to a file so that we can access it from menu scope if we want to
        if not file.Exists("ogl", "DATA") then file.CreateDir("ogl") end
        local f = file.Open("ogl/sv_loadingurl.txt", "w", "DATA")
        if f then
            f:Write(ogl_svloading .. OGL_BuildLinkArgs())
            f:Close()
        end
    end
end

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

-- Set the screen only when players join
-- If I leave the command configured, the screen will continue to be displayed after being uninstalled
hook.Add("PlayerConnect", "OGL_PlyConnect", function(name, ip)
	SetLoadingScreen()

    timer.Create("OGL_WaitUntilThePlayerSeesTheScreen", 15, 1, function() -- Don't use a unique name!
        RunConsoleCommand("sv_loadingurl", "")
    end)
end)