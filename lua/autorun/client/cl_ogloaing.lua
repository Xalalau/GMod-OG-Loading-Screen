-- Run commands os the server
local function OGL_SendToServer(command, value)
	net.Start("OGL_UpdateCVar")
		net.WriteString(command)
		net.WriteString(tostring(value))
	net.SendToServer()
end

-- Run slider commands on the server
local function OGL_SendToServer_Slider(command, value)
	OGL_SendToServer(command, math.Round(value))
end

-- Check admin
local function checkAdmin()
    local ply = LocalPlayer()

    if ply:IsValid() then
        if ply:IsAdmin() or ply:IsSuperAdmin() then
            return true
        end
    end

    return false
end

-- Build menu
function Panel(CPanel)
    local setup

    CPanel:Help("Customize your server loading screen.")

    CPanel:Help("")
	setup = vgui.Create("DCollapsibleCategory", CPanel)
	setup:SetLabel("Floating Icons")
	setup:Dock(TOP)

    setup = CPanel:AddControl ("CheckBox", { Label = "Enable", Command = "ogl_floating" })
    setup.OnChange = function(self, bVal) OGL_SendToServer("ogl_floating", bVal) end
	setup:SetValue(GetConVar("ogl_floating"):GetInt())

    CPanel:Help("")
	setup = vgui.Create("DCollapsibleCategory", CPanel)
	setup:SetLabel("Icons Box")
	setup:Dock(TOP)

    setup = CPanel:AddControl ("CheckBox", { Label = "Enable", Command = "ogl_box" })
    setup.OnChange = function(self, bVal) OGL_SendToServer("ogl_box", bVal) end
	setup:SetValue(GetConVar("ogl_box"):GetInt())

    setup = CPanel:AddControl ("CheckBox", { Label = "Pop sound", Command = "ogl_audio" })
    setup.OnChange = function(self, bVal) OGL_SendToServer("ogl_audio", bVal) end
	setup:SetValue(GetConVar("ogl_audio"):GetInt())

    setup = CPanel:AddControl ("Slider"  , { Label = "Lines", Type = "int", Min = "1", Max = "15", Command = "ogl_boxLines"})
	setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_boxLines", val) end
	setup:SetValue(GetConVar("ogl_boxLines"):GetInt())

    setup = CPanel:AddControl ("Slider"  , { Label = "Icons Per Line", Type = "int", Min = "1", Max = "70", Command = "ogl_boxIconsPerLine"})
	setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_boxIconsPerLine", val) end
	setup:SetValue(GetConVar("ogl_boxIconsPerLine"):GetInt())

    CPanel:Help("")
	setup = vgui.Create("DCollapsibleCategory", CPanel)
	setup:SetLabel("Messages")
	setup:Dock(TOP)

    setup = CPanel:AddControl ("Slider"  , { Label = "Amount", Type = "int", Min = "0", Max = "25", Command = "ogl_messages"})
	setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_messages", val) end
	setup:SetValue(GetConVar("ogl_messages"):GetInt())

    setup = CPanel:AddControl ("Slider"  , { Label = "Random Msgs Delay", Type = "int", Min = "0", Max = "25", Command = "ogl_randMsgSecs"})
	setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_randMsgSecs", val) end
	setup:SetValue(GetConVar("ogl_randMsgSecs"):GetInt())
    CPanel:ControlHelp("The time it takes for a random message to appear if nothing is happening.")

    CPanel:Help("")
	setup = vgui.Create("DCollapsibleCategory", CPanel)
	setup:SetLabel("General")
	setup:Dock(TOP)

	setup = CPanel:AddControl ("TextBox"  , { Label = "Main Image URL" })
	local textInit = false
	setup.OnEnter = function(self, val)
		if not textInit then return end
		val = string.Replace(val, "http://", "_1_")
		val = string.Replace(val, "https://", "_2_")
		val = string.Replace(val, "/", "(47)")
		val = string.Replace(val, " ", "")
		RunConsoleCommand("ogl_img", val)
		OGL_SendToServer("ogl_img", val)
	end
	local command = GetConVar("ogl_img"):GetString()
	command = string.Replace(command, "_1_", "http://")
	command = string.Replace(command, "_2_", "https://")
	command = string.Replace(command, "(47)", "/")
	setup:SetText(command)
	timer.Simple(1, function() textInit = true end)
    CPanel:ControlHelp("e.g. https://i.imgur.com/PypI0Rp.png")

	setup = CPanel:AddControl ("Slider"  , { Label = "Icon Width", Type = "int", Min = "1", Max = "64", Command = "ogl_iconW"})
	setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_iconW", val) end
	setup:SetValue(GetConVar("ogl_iconW"):GetInt())

    setup = CPanel:AddControl ("Slider"  , { Label = "Icon Height", Type = "int", Min = "1", Max = "64", Command = "ogl_iconH"})
	setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_iconH", val) end
	setup:SetValue(GetConVar("ogl_iconH"):GetInt())

    setup = CPanel:AddControl ("Button"  , { Label = "Simulate Loading Screen" })
	setup.DoClick = function()
		gui.OpenURL(ogl_svloading .. OGL_BuildLinkArgs() .. "simulate=true")
	end

	--[[
    setup = CPanel:AddControl ("CheckBox", { Label = "Pop sound", Command = "ogl_debug" })
    setup.OnChange = function(self, bVal) OGL_SendToServer("ogl_debug", bVal) end
	setup:SetValue(GetConVar("ogl_debug"):GetInt())
	]]
end

hook.Add("PopulateToolMenu", "OG Loading Screen Populate", function ()
    if not checkAdmin() then
        spawnmenu.AddToolMenuOption("Utilities", "Admin", "OG Loading Screen", "OG Loading Screen", "", "", Panel)
    end
end)