ogl_svloading = "https://xalalau.com/modulos/sv_loadingurl/index.php"

-- The name of the variables is compact to save the link size.
olg_cvars = {
    ogl_f = true, -- Floating
    ogl_b = false, -- Box
    ogl_bS = true, -- Box pop sound
    ogl_bR = 60, -- Box rows
    ogl_bL = 1, -- Box lines
    ogl_m = 18, -- Messages
    ogl_rMD = 15, -- Random messages delay
    ogl_bkD = false, -- Dark mode
    ogl_bkR = "255", -- R
    ogl_bkG = "255", -- G
    ogl_bkB = "255", -- B
    ogl_bkI = "", -- Image
    ogl_bkP = "cc", -- Position (center center)
    ogl_bkS = "ct", -- Size (contain)
    ogl_bkRe = "n", -- Repet (no-repeat)
    ogl_l = "", -- logo
    ogl_iW = 16, -- Icon width
    ogl_iH = 16, -- Icon height
    --ogl_dF = false -- Debug floating icons
}

for k,v in pairs(olg_cvars) do
    if ! ConVarExists(k) then
        CreateConVar(k, tostring(v), { FCVAR_ARCHIVE })
    end
end

function OGL_BuildLinkArgs()
    local linkArgs = "?"

    for command,_ in pairs(olg_cvars) do
        local value = GetConVar(command):GetString()
        value = value != "0" and value or "false"
        value = value == "true" and "1" or value
        linkArgs = linkArgs .. command .. "=" .. value .. "&"
    end

    return string.Replace(linkArgs, "ogl_", "")
end
