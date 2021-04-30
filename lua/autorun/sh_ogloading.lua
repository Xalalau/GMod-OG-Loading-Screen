ogl_svloading = "https://3grng17dtqmxmsey95qy0w-on.drv.tw/gmod%20og%20loading%20screen/ogl-screen.html"

olg_cvars = {
	ogl_floating = true,
	ogl_box = false,
	ogl_boxAudio = true,
	ogl_boxIconsPerLine = 60,
	ogl_boxLines = 1,
	ogl_messages = 18,
	ogl_randMsgSecs = 15,
	ogl_img = "",
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
		linkArgs = linkArgs .. command .. "=" .. GetConVar(command):GetString() .. "&"
	end

	return string.Replace(linkArgs, "ogl_", "")
end
