ogl_svloading = "https://3grng17dtqmxmsey95qy0w-on.drv.tw/gmod%20og%20loading%20screen/oglscreen2.html"

olg_cvars = {
    ogl_floating = true,
    ogl_box = false,
    ogl_boxAudio = true,
    ogl_boxIconsPerLine = 60,
    ogl_boxLines = 1,
    ogl_messages = 18,
    ogl_randMsgSecs = 15,
    ogl_bkDark = false,
    ogl_bkColorR = "255",
    ogl_bkColorG = "255",
    ogl_bkColorB = "255",
    ogl_bkImage = "",
    ogl_bkPosition = "center_center",
    ogl_bkSize = "contain",
    ogl_bkRepeat = "no-repeat",
    ogl_logo = "",
    ogl_iconW = 16,
    ogl_iconH = 16,
    --ogl_debugFloating = false
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
        linkArgs = linkArgs .. command .. "=" .. value .. "&"
    end

    return string.Replace(linkArgs, "ogl_", "")
end
