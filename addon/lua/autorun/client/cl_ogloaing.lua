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
local function CheckAdmin()
    local ply = LocalPlayer()

    if ply:IsValid() then
        if ply:IsAdmin() or ply:IsSuperAdmin() then
            return true
        end
    end

    return false
end

local function PackLink(link)
    link = string.Replace(link, "http://", "_1_")
    link = string.Replace(link, "https://", "_2_")
    link = string.Replace(link, "/", "(47)")
    link = string.Replace(link, " ", "")
    return link
end

local function UnpackLink(packedLink)
    local link
    link = string.Replace(packedLink, "_1_", "http://")
    link = string.Replace(link, "_2_", "https://")
    link = string.Replace(link, "(47)", "/")
    return link
end

local function TestScreen()
    local frame = vgui.Create("DFrame")

    local width = ScrW() * 0.95
    local height = ScrH() * 0.95

    frame:SetTitle("OG Simulation")
    frame:SetSize(width, height)
    frame:Center()
    frame:MakePopup()
    frame:SetDeleteOnClose(true)

    local html = vgui.Create("DHTML", frame)

    html:SetHTML([[
        window.onerror = function(msg, url, lineNo, columnNo, error) {
            console.log("Error: " + msg + " at line " + lineNo);
            return false;
        };
    ]])

    html:Dock(FILL)
    html:OpenURL(ogl_svloading .. OGL_BuildLinkArgs() .. "s=1")
    --html:OpenURL("asset://garrysmod/html/host/index.html" .. OGL_BuildLinkArgs() .. "s=1")
end

-- Build menu
local window
local function BuildPanel(CPanel)
    if not CheckAdmin() then
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

        setup = OGPNL:AddControl(pnl, "CheckBox", { Label = "Enable", Command = "ogl_f" })
        setup.OnChange = function(self, bVal) OGL_SendToServer("ogl_f", bVal) end

        OGPNL:Help(pnl, "")

        setup = vgui.Create("DCollapsibleCategory", pnl)
        setup:SetLabel("Icons Box")
        setup:Dock(TOP)

        setup = OGPNL:AddControl(pnl, "CheckBox", { Label = "Enable", Command = "ogl_b" })
        setup.OnChange = function(self, bVal) OGL_SendToServer("ogl_b", bVal) end

        setup = OGPNL:AddControl(pnl, "CheckBox", { Label = "Pop sound", Command = "ogl_bS" })
        setup.OnChange = function(self, bVal) OGL_SendToServer("ogl_bS", bVal) end

        setup = OGPNL:AddControl(pnl, "Slider"  , { Label = "Lines", Type = "int", Min = "1", Max = "15", Command = "ogl_bL"})
        setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_bL", val) end

        setup = OGPNL:AddControl(pnl, "Slider"  , { Label = "Rows", Type = "int", Min = "1", Max = "70", Command = "ogl_bR"})
        setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_bR", val) end

        OGPNL:Help(pnl, "")

        setup = vgui.Create("DCollapsibleCategory", pnl)
        setup:SetLabel("Messages")
        setup:Dock(TOP)

        setup = OGPNL:AddControl(pnl, "Slider"  , { Label = "Amount", Type = "int", Min = "0", Max = "25", Command = "ogl_m"})
        setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_m", val) end

        setup = OGPNL:AddControl(pnl, "Slider"  , { Label = "Random Msgs Delay", Type = "int", Min = "1", Max = "25", Command = "ogl_rMD"})
        setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_rMD", val) end
        OGPNL:ControlHelp(pnl, "The time it takes for a random message to appear if nothing is happening.")

        OGPNL:Help(pnl, "")

        setup = vgui.Create("DCollapsibleCategory", pnl)
        setup:SetLabel("Background")
        setup:Dock(TOP)

        setup = OGPNL:AddControl(pnl, "CheckBox", { Label = "Dark Mode", Command = "ogl_bkD" })
        setup.OnChange = function(self, bVal) OGL_SendToServer("ogl_bkD", bVal) end

        setup = OGPNL:AddControl(pnl, "Color", { Label = "Color", red = "ogl_bkR", green = "ogl_bkG", blue = "ogl_bkB" })
        setup.Mixer.ValueChanged = function(self, col)
            OGL_SendToServer("ogl_bkR", col.r)
            OGL_SendToServer("ogl_bkG", col.g)
            OGL_SendToServer("ogl_bkB", col.b)
        end

        setup = OGPNL:AddControl(pnl, "TextBox"  , { Label = "Background URL" })
        setup:SetUpdateOnType(true)
        setup:SetText(UnpackLink(GetConVar("ogl_bkI"):GetString()))
        setup.OnValueChange = function(self, val)
            val = PackLink(val)
            RunConsoleCommand("ogl_bkI", val)
            OGL_SendToServer("ogl_bkI", val)
        end
        OGPNL:ControlHelp(pnl, "e.g. https://i.imgur.com/Ld56Sap.png")

        local posOptions = {
            ["Left Top"] = "lt",
            ["Left Center"] = "lc",
            ["Left Bottom"] = "lb",
            ["Right Top"] = "rt",
            ["Right Center"] = "rc",
            ["Right Bottom"] = "rb",
            ["Center Top"] = "ct",
            ["Center Center"] = "cc",
            ["Center Bottom"] = "cb",
        }
        setup = OGPNL:AddControl(pnl, "ComboBox", { Command = "ogl_bkP", Label = "Position" })
        local curentBkPosition = GetConVar("ogl_bkP"):GetString()
        for k,v in pairs(posOptions) do
            if v == curentBkPosition then curentBkPosition = k end
            setup:AddChoice(k, v)
        end
        setup:SetValue(curentBkPosition)
        setup.OnSelect = function(self, index, text, data)
            RunConsoleCommand("ogl_bkP", data)
            OGL_SendToServer("ogl_bkP", data)
        end

        local sizeOptions = {
            ["Original"] = "a", -- auto
            ["Stretch"] = "cv", -- cover
            ["Fully Visible"] = "ct", -- contain
        }
        setup = OGPNL:AddControl(pnl, "ComboBox", { Command = "ogl_bkS", Label = "Size" })
        local curentBkSize = GetConVar("ogl_bkS"):GetString()
        for k,v in pairs(sizeOptions) do
            if v == curentBkSize then curentBkSize = k end
            setup:AddChoice(k, v)
        end
        setup:SetValue(curentBkSize)
        setup.OnSelect = function(self, index, text, data)
            RunConsoleCommand("ogl_bkS", data)
            OGL_SendToServer("ogl_bkS", data)
        end

        local repeatOptions = {
            ["No"] = "n", -- no-repeat
            ["Horizontal"] = "x", -- repeat-x
            ["Vertical"] = "y", -- repeat-y
            ["Horizontal / Vertical"] = "r", -- repeat
        }
        setup = OGPNL:AddControl(pnl, "ComboBox", { Command = "ogl_bkRe", Label = "Repeat" })
        local curentBkRepeat = GetConVar("ogl_bkRe"):GetString()
        for k,v in pairs(repeatOptions) do
            if v == curentBkRepeat then curentBkRepeat = k end
            setup:AddChoice(k, v)
        end
        setup:SetValue(curentBkRepeat)
        setup.OnSelect = function(self, index, text, data)
            RunConsoleCommand("ogl_bkRe", data)
            OGL_SendToServer("ogl_bkRe", data)
        end

        OGPNL:Help(pnl, "")

        setup = vgui.Create("DCollapsibleCategory", pnl)
        setup:SetLabel("General")
        setup:Dock(TOP)

        setup = OGPNL:AddControl(pnl, "TextBox", { Label = "Logo URL" })
        setup:SetUpdateOnType(true)
        setup:SetText(UnpackLink(GetConVar("ogl_l"):GetString()))
        setup.OnValueChange = function(self, val)
            val = PackLink(val)
            RunConsoleCommand("ogl_l", val)
            OGL_SendToServer("ogl_l", val)
        end
        OGPNL:ControlHelp(pnl, "e.g. https://i.imgur.com/PypI0Rp.png")

        setup = OGPNL:AddControl(pnl, "Slider"  , { Label = "Icon Width", Type = "int", Min = "1", Max = "64", Command = "ogl_iW"})
        setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_iW", val) end

        setup = OGPNL:AddControl(pnl, "Slider"  , { Label = "Icon Height", Type = "int", Min = "1", Max = "64", Command = "ogl_iH"})
        setup.OnValueChanged = function(self, val) OGL_SendToServer_Slider("ogl_iH", val) end

        setup = OGPNL:AddControl(pnl, "Button"  , { Label = "Simulate Loading Screen" })
        setup.DoClick = function()
            TestScreen()
        end
        OGPNL:ControlHelp(pnl, "If you've activated the pop sound and want to hear it, click anywhere in the simulation.")

        --[[
        setup = OGPNL:AddControl(pnl, "CheckBox", { Label = "Pop sound", Command = "ogl_dF" })
        setup.OnChange = function(self, bVal) OGL_SendToServer("ogl_dF", bVal) end
        setup:SetValue(GetConVar("ogl_dF"):GetInt())
        ]]

        OGPNL:Help(pnl, "")
    else
        window:Show()
    end
end

concommand.Add("ogl_menu", BuildPanel)