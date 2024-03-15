
addon = WorkshopFileBase( "addon", {} )

local backupGetLoadPanel = GetLoadPanel

local function IsOGLMounted()
    local addons = engine.GetAddons()

    for k, addon in ipairs(addons) do
        if addon.wsid == "2471861417" then
            if addon.mounted then
                return true
            else
                break
            end
        end
    end

    return false
end

function GetLoadPanel()
    local pnlLoading = backupGetLoadPanel()

    if not IsValid(pnlLoading) then
		pnlLoading = vgui.CreateFromTable(PanelType_Loading)
	end

    pnlLoading.OnActivate = function(self)
        g_ServerName	= ""
        g_MapName		= ""
        g_ServerURL		= ""
        g_MaxPlayers	= ""
        g_SteamID		= ""

        local html

        if IsOGLMounted() then
            local f = file.Open("ogl/sv_loadingurl.txt", "r", "DATA")
            if f then html = f:ReadLine() end
            f:Close()
        end

        if not html then html = GetDefaultLoadingHTML() end

        self:ShowURL(html)

        self.NumDownloadables = 0
    end

	return pnlLoading
end
