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
local window
local function BuildPanel(CPanel)
    if not checkAdmin() then return end

    if not window then
        local topBar, border = 25, 5
        local width, height = 280, 550

        window = vgui.Create("DFrame")
            window:SetSize(width, height)
            window:SetPos(ScrW()/2 - width/2, ScrH()/2 - height/2)
            window:SetTitle("OG Loading Screen")
            window:ShowCloseButton(true)
            window:MakePopup()
            window:SetDeleteOnClose(false)
            window.OnClose = function()
                window:Hide()
            end

        local pnl = vgui.Create("DScrollPanel", window)
            pnl:SetWidth(window:GetSize() - border * 2)
            pnl:SetHeight(window:GetTall() - topBar - border)
            pnl:SetPos(border, topBar)
            pnl:SetBackgroundColor(color_white)

        local setup

        OGPNL:Init(pnl)

        OGPNL:Help(pnl, "Customize your server loading screen.")

        OGPNL:Help(pnl, "")

        setup = vgui.Create("DCollapsibleCategory", pnl)
        setup:SetLabel("Floating Icons")
        setup:Dock(TOP)

        setup = OGPNL:AddControl(pnl, "CheckBox", { Label = "Enable", Command = "ogl_floating" })
        setup.OnChange = function(self, bVal) OGL_SendToServer("ogl_floating", bVal) end

        OGPNL:Help(pnl, "")

        setup = vgui.Create("DCollapsibleCategory", pnl)
        setup:SetLabel("Icons Box")
        setup:Dock(TOP)

        setup = OGPNL:AddControl(pnl, "CheckBox", { Label = "Enable", Command = "ogl_box" })
        setup.OnChange = function(self, bVal) OGL_SendToServer("ogl_box", bVal) end

        setup = OGPNL:AddControl(pnl, "CheckBox", { Label = "Pop sound", Command = "ogl_boxAudio" })
        setup.OnChange = function(self, bVal) OGL_SendToServer("ogl_boxAudio", bVal) end

        setup = OGPNL:AddControl(pnl, "Slider"  , { Label = "Lines", Type = "int", Min = "1", Max = "15", Command = "ogl_boxLines"})
        setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_boxLines", val) end

        setup = OGPNL:AddControl(pnl, "Slider"  , { Label = "Icons Per Line", Type = "int", Min = "1", Max = "70", Command = "ogl_boxIconsPerLine"})
        setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_boxIconsPerLine", val) end

        OGPNL:Help(pnl, "")

        setup = vgui.Create("DCollapsibleCategory", pnl)
        setup:SetLabel("Messages")
        setup:Dock(TOP)

        setup = OGPNL:AddControl(pnl, "Slider"  , { Label = "Amount", Type = "int", Min = "0", Max = "25", Command = "ogl_messages"})
        setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_messages", val) end

        setup = OGPNL:AddControl(pnl, "Slider"  , { Label = "Random Msgs Delay", Type = "int", Min = "0", Max = "25", Command = "ogl_randMsgSecs"})
        setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_randMsgSecs", val) end
        OGPNL:ControlHelp(pnl, "The time it takes for a random message to appear if nothing is happening.")

        OGPNL:Help(pnl, "")

        setup = vgui.Create("DCollapsibleCategory", pnl)
        setup:SetLabel("General")
        setup:Dock(TOP)

        setup = OGPNL:AddControl(pnl, "TextBox"  , { Label = "Main Image URL" })
        local textInit = false
        setup.OnValueChange = function(self, val)
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
        OGPNL:ControlHelp(pnl, "e.g. https://i.imgur.com/PypI0Rp.png")

        setup = OGPNL:AddControl(pnl, "Slider"  , { Label = "Icon Width", Type = "int", Min = "1", Max = "64", Command = "ogl_iconW"})
        setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_iconW", val) end

        setup = OGPNL:AddControl(pnl, "Slider"  , { Label = "Icon Height", Type = "int", Min = "1", Max = "64", Command = "ogl_iconH"})
        setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_iconH", val) end

        setup = OGPNL:AddControl(pnl, "Button"  , { Label = "Simulate Loading Screen" })
        setup.DoClick = function()
            gui.OpenURL(ogl_svloading .. OGL_BuildLinkArgs() .. "simulate=true")
        end
        OGPNL:ControlHelp(pnl, "If you've activated the pop sound and want to hear it, click anywhere in the simulation.")

        --[[
        setup = OGPNL:AddControl(pnl, "CheckBox", { Label = "Pop sound", Command = "ogl_debugFloating" })
        setup.OnChange = function(self, bVal) OGL_SendToServer("ogl_debugFloating", bVal) end
        setup:SetValue(GetConVar("ogl_debugFloating"):GetInt())
        ]]

        OGPNL:Help(pnl, "")
    else
        window:Show()
    end
end

concommand.Add("ogl_menu", BuildPanel)