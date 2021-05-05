util.AddNetworkString("OGL_UpdateCVar")

-- Set the new sv_loadingurl link
local function SetLoadingScreen()
    local command = ogl_svloading .. OGL_BuildLinkArgs()
    local comSize = string.len(command)

    if string.len(command) > 494 then
        local warning = "WARNING! sv_loadingurl is too big! Max size is 494, yours is " .. comSize .. ". Shorten your image links." 
        print(warning)
        PrintMessage(HUD_PRINTTALK, warning)
    else
        RunConsoleCommand("sv_loadingurl", ogl_svloading .. OGL_BuildLinkArgs())
    end
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