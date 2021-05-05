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

local function packLink(link)
    link = string.Replace(link, "http://", "_1_")
    link = string.Replace(link, "https://", "_2_")
    link = string.Replace(link, "/", "(47)")
    link = string.Replace(link, " ", "")
    return link
end

local function unpackLink(packedLink)
    local link
    link = string.Replace(packedLink, "_1_", "http://")
    link = string.Replace(link, "_2_", "https://")
    link = string.Replace(link, "(47)", "/")
    return link
end

-- Build menu
local window
local function BuildPanel(CPanel)
    if not checkAdmin() then
        print("Admin only.")

        return
    end

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

        setup = OGPNL:AddControl(pnl, "Slider"  , { Label = "Random Msgs Delay", Type = "int", Min = "1", Max = "25", Command = "ogl_randMsgSecs"})
        setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_randMsgSecs", val) end
        OGPNL:ControlHelp(pnl, "The time it takes for a random message to appear if nothing is happening.")

        OGPNL:Help(pnl, "")

        setup = vgui.Create("DCollapsibleCategory", pnl)
        setup:SetLabel("Background")
        setup:Dock(TOP)

        setup = OGPNL:AddControl(pnl, "CheckBox", { Label = "Dark Mode", Command = "ogl_bkDark" })
        setup.OnChange = function(self, bVal) OGL_SendToServer("ogl_bkDark", bVal) end

        setup = OGPNL:AddControl(pnl, "Color", { Label = "Color", red = "ogl_bkColorR", green = "ogl_bkColorG", blue = "ogl_bkColorB" })
        setup.Mixer.ValueChanged = function(self, col)
            OGL_SendToServer("ogl_bkColorR", col.r)
            OGL_SendToServer("ogl_bkColorG", col.g)
            OGL_SendToServer("ogl_bkColorB", col.b)
        end

        setup = OGPNL:AddControl(pnl, "TextBox"  , { Label = "Background URL" })
        setup:SetUpdateOnType(true)
        setup:SetText(unpackLink(GetConVar("ogl_bkImage"):GetString()))
        setup.OnValueChange = function(self, val)
            val = packLink(val)
            RunConsoleCommand("ogl_bkImage", val)
            OGL_SendToServer("ogl_bkImage", val)
        end
        OGPNL:ControlHelp(pnl, "e.g. https://i.imgur.com/Ld56Sap.png")

        local posOptions = {
            ["Left Top"] = "left_top",
            ["Left Center"] = "left_center",
            ["Left Bottom"] = "left_bottom",
            ["Right Top"] = "right_top",
            ["Right Center"] = "right_center",
            ["Right Bottom"] = "right_bottom",
            ["Center Top"] = "center_top",
            ["Center Center"] = "center_center",
            ["Center Bottom"] = "center_bottom",
        }
        setup = OGPNL:AddControl(pnl, "ComboBox", { Command = "ogl_bkPosition", Label = "Position" })
        local curentBkPosition = GetConVar("ogl_bkPosition"):GetString()
        for k,v in pairs(posOptions) do
            if v == curentBkPosition then curentBkPosition = k end
            setup:AddChoice(k, v)
        end
        setup:SetValue(curentBkPosition)
        setup.OnSelect = function(self, index, text, data)
            RunConsoleCommand("ogl_bkPosition", data)
            OGL_SendToServer("ogl_bkPosition", data)
        end

        local sizeOptions = {
            ["Original"] = "auto",
            ["Stretch"] = "cover",
            ["Fully Visible"] = "contain",
        }
        setup = OGPNL:AddControl(pnl, "ComboBox", { Command = "ogl_bkSize", Label = "Size" })
        local curentBkSize = GetConVar("ogl_bkSize"):GetString()
        for k,v in pairs(sizeOptions) do
            if v == curentBkSize then curentBkSize = k end
            setup:AddChoice(k, v)
        end
        setup:SetValue(curentBkSize)
        setup.OnSelect = function(self, index, text, data)
            RunConsoleCommand("ogl_bkSize", data)
            OGL_SendToServer("ogl_bkSize", data)
        end

        local repeatOptions = {
            ["No"] = "no-repeat",
            ["Horizontal"] = "repeat-x",
            ["Vertical"] = "repeat-y",
            ["Horizontal / Vertical"] = "repeat",
        }
        setup = OGPNL:AddControl(pnl, "ComboBox", { Command = "ogl_bkRepeat", Label = "Repeat" })
        local curentBkRepeat = GetConVar("ogl_bkRepeat"):GetString()
        for k,v in pairs(repeatOptions) do
            if v == curentBkRepeat then curentBkRepeat = k end
            setup:AddChoice(k, v)
        end
        setup:SetValue(curentBkRepeat)
        setup.OnSelect = function(self, index, text, data)
            RunConsoleCommand("ogl_bkRepeat", data)
            OGL_SendToServer("ogl_bkRepeat", data)
        end

        OGPNL:Help(pnl, "")

        setup = vgui.Create("DCollapsibleCategory", pnl)
        setup:SetLabel("General")
        setup:Dock(TOP)

        setup = OGPNL:AddControl(pnl, "TextBox"  , { Label = "Logo URL" })
        setup:SetUpdateOnType(true)
        setup:SetText(unpackLink(GetConVar("ogl_logo"):GetString()))
        setup.OnValueChange = function(self, val)
            val = packLink(val)
            RunConsoleCommand("ogl_logo", val)
            OGL_SendToServer("ogl_logo", val)
        end
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