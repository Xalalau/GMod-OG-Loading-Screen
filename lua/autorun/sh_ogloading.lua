olg_cvars = {
	ogl_floating = true,
	ogl_box = false,
	ogl_boxIconsPerLine = 60,
	ogl_boxLines = 1,
	ogl_messages = 18,
	ogl_randMsgSecs = 15,
	ogl_audio = true,
	ogl_img = "",
	ogl_iconW = 16,
	ogl_iconH = 16,
	--ogl_debug = false
}

for k,v in pairs(olg_cvars) do
	if ! ConVarExists(k) then
		CreateConVar(k, tostring(v), { FCVAR_ARCHIVE })
	end
end
