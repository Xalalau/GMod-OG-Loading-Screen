-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Interface ported from https://github.com/Facepunch/garrysmod/blob/be251723824643351cb88a969818425d1ddf42b3/garrysmod/lua/vgui/dform.lua
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

OGPNL = {}

function OGPNL:Init(pnl)

    local tab = pnl:GetTable()

	tab.Items = {}

    AccessorFunc( tab, "m_bSizeToContents",	"AutoSize", FORCE_BOOL)
    AccessorFunc( tab, "m_iSpacing",			"Spacing" )
    AccessorFunc( tab, "m_Padding",			"Padding" )

	pnl:SetSpacing( 4 )
	pnl:SetPadding( 10 )

	pnl:SetPaintBackground( true )

	pnl:SetMouseInputEnabled( true )
	pnl:SetKeyboardInputEnabled( true )
end

function OGPNL:AddItem( pnl, left, right )

	pnl:InvalidateLayout()

	local Panel = vgui.Create( "DSizeToContents", pnl )
	--Panel.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "CategoryButton", panel, w, h ) end
	Panel:SetSizeX( false )
	Panel:Dock( TOP )
	Panel:DockPadding( 10, 10, 10, 0 )
	Panel:InvalidateLayout()

	if ( IsValid( right ) ) then

		left:SetParent( Panel )
		left:Dock( LEFT )
		left:InvalidateLayout( true )
		left:SetSize( 100, 20 )

		right:SetParent( Panel )
		right:SetPos( 110, 0 )
		right:InvalidateLayout( true )

	elseif ( IsValid( left ) ) then

		left:SetParent( Panel )
		left:Dock( TOP )

	end

	table.insert( pnl:GetTable().Items, Panel )

end

function OGPNL:TextEntry( pnl, strLabel, strConVar )

	local left = vgui.Create( "DLabel", pnl )
	left:SetText( strLabel )
	left:SetDark( true )

	local right = vgui.Create( "DTextEntry", pnl )
	right:SetConVar( strConVar )
	right:Dock( TOP )

	self:AddItem( pnl, left, right )

	return right, left

end

function OGPNL:ComboBox( pnl, strLabel, strConVar )

	local left = vgui.Create( "DLabel", pnl )
	left:SetText( strLabel )
	left:SetDark( true )

	local right = vgui.Create( "DComboBox", pnl )
	right:SetConVar( strConVar )
	right:Dock( FILL )
	function right:OnSelect( index, value, data )
		if ( !pnl:GetTable().m_strConVar ) then return end
		RunConsoleCommand( pnl:GetTable().m_strConVar, tostring( data or value ) )
	end

	self:AddItem( pnl, left, right )

	return right, left

end

function OGPNL:NumberWang( pnl, strLabel, strConVar, numMin, numMax, numDecimals )

	local left = vgui.Create( "DLabel", pnl )
	left:SetText( strLabel )
	left:SetDark( true )

	local right = vgui.Create( "DNumberWang", pnl )
	right:SetMinMax( numMin, numMax )

	if ( numDecimals != nil ) then right:SetDecimals( numDecimals ) end

	right:SetConVar( strConVar )
	right:SizeToContents()

	self:AddItem( pnl, left, right )

	return right, left

end

function OGPNL:NumSlider( pnl, strLabel, strConVar, numMin, numMax, numDecimals )

	local left = vgui.Create( "DNumSlider", pnl )
	left:SetText( strLabel )
	left:SetMinMax( numMin, numMax )
	left:SetDark( true )

	if ( numDecimals != nil ) then left:SetDecimals( numDecimals ) end

	left:SetConVar( strConVar )
	left:SizeToContents()

	self:AddItem( pnl, left, nil )

	return left

end

function OGPNL:CheckBox( pnl, strLabel, strConVar )

	local left = vgui.Create( "DCheckBoxLabel", pnl )
	left:SetText( strLabel )
	left:SetDark( true )
	left:SetConVar( strConVar )

	self:AddItem( pnl, left, nil )

	return left

end

function OGPNL:Help( pnl, strHelp )

	local left = vgui.Create( "DLabel", pnl )

	left:SetDark( true )
	left:SetWrap( true )
	left:SetTextInset( 0, 0 )
	left:SetText( strHelp )
	left:SetContentAlignment( 7 )
	left:SetAutoStretchVertical( true )
	left:DockMargin( 8, 0, 8, 8 )

	self:AddItem( pnl, left, nil )

	left:InvalidateLayout( true )

	return left

end

function OGPNL:ControlHelp( pnl, strHelp )

	local Panel = vgui.Create( "DSizeToContents", pnl )
	Panel:SetSizeX( false )
	Panel:Dock( TOP )
	Panel:InvalidateLayout()

	local left = vgui.Create( "DLabel", Panel )
	left:SetDark( true )
	left:SetWrap( true )
	left:SetTextInset( 0, 0 )
	left:SetText( strHelp )
	left:SetContentAlignment( 5 )
	left:SetAutoStretchVertical( true )
	left:DockMargin( 32, 0, 32, 8 )
	left:Dock( TOP )
	left:SetTextColor( pnl:GetSkin().Colours.Tree.Hover )

	table.insert( pnl:GetTable().Items, Panel )

	return left

end

--[[---------------------------------------------------------
	Note: If you're running a console command like "maxplayers 10" you
	need to add the "10" to the arguments, like so
	Button( "LabelName", "maxplayers", "10" )
-----------------------------------------------------------]]
function OGPNL:Button( pnl, strName, strConCommand, ... --[[ console command args!! --]] )

	local left = vgui.Create( "DButton", pnl )

	if ( strConCommand ) then
		left:SetConsoleCommand( strConCommand, ... )
	end

	left:SetText( strName )
	self:AddItem( pnl, left, nil )

	return left

end

function OGPNL:ListBox( pnl, strLabel )

	if ( strLabel ) then
		local left = vgui.Create( "DLabel", pnl )
		left:SetText( strLabel )
		self:AddItem( pnl, left )
		left:SetDark( true )
	end

	local right = vgui.Create( "DListBox", pnl )
	--right:SetConVar( strConVar )
	right.Stretch = true

	self:AddItem( pnl, right )

	return right, left

end


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Interface ported from https://github.com/Facepunch/garrysmod/blob/be251723824643351cb88a969818425d1ddf42b3/garrysmod/gamemodes/sandbox/gamemode/spawnmenu/controlpanel.lua
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--[[---------------------------------------------------------
	Name: AddPanel
-----------------------------------------------------------]]
function OGPNL:AddPanel( pnl, addPnl )

	self:AddItem( pnl, addPnl, nil )
	pnl:InvalidateLayout()

end

--[[---------------------------------------------------------
	Name: MatSelect
-----------------------------------------------------------]]
function OGPNL:MatSelect( pnl, strConVar, tblOptions, bAutoStretch, iWidth, iHeight )

	local MatSelect = vgui.Create( "MatSelect", pnl )
	Derma_Hook( MatSelect.List, "Paint", "Paint", "Panel" )

	MatSelect:SetConVar( strConVar )

	if ( bAutoStretch != nil ) then MatSelect:SetAutoHeight( bAutoStretch ) end
	if ( iWidth != nil ) then MatSelect:SetItemWidth( iWidth ) end
	if ( iHeight != nil ) then MatSelect:SetItemHeight( iHeight ) end

	if ( tblOptions != nil ) then
		for k, v in pairs( tblOptions ) do
			local label = k
			if ( isnumber( label ) ) then label = v end
			MatSelect:AddMaterial( label, v )
		end
	end

	self:AddPanel( pnl, MatSelect )
	return MatSelect

end

--[[---------------------------------------------------------
	Name: ControlValues
-----------------------------------------------------------]]
function OGPNL:ControlValues( pnl, data )
	if ( data.label) then
		pnl:SetLabel( data.label )
	end
	if ( data.closed ) then
		pnl:SetExpanded( false )
	end
end

--[[---------------------------------------------------------
	Name: AddControl
-----------------------------------------------------------]]
function OGPNL:AddControl( pnl, control, data )

	local data = table.LowerKeyNames( data )
	local original = control
	control = string.lower( control )

	if ( control == "header" ) then

		if ( data.description ) then
			local ctrl = self:Help( pnl, data.description )
			return ctrl
		end

		return
	end

	if ( control == "textbox" ) then

		local ctrl = self:TextEntry( pnl, data.label or "Untitled", data.command )
		return ctrl

	end

	if ( control == "label" ) then

		local ctrl = self:Help( pnl, data.text )
		return ctrl

	end

	if ( control == "checkbox" or control == "toggle" ) then

		local ctrl = self:CheckBox( pnl, data.label or "Untitled", data.command )

		if ( data.help ) then
			self:ControlHelp( pnl, data.label .. ".help" )
		end

		return ctrl

	end

	if ( control == "slider" ) then

		local Decimals = 0
		if ( data.type && string.lower(data.type) == "float" ) then Decimals = 2 end

		local ctrl = self:NumSlider( pnl, data.label or "Untitled", data.command, data.min or 0, data.max or 100, Decimals )

		if ( data.help ) then
			self:ControlHelp( pnl, data.label .. ".help" )
		end

		if ( data.default ) then
			ctrl:SetDefaultValue( data.default )
		elseif ( data.command ) then
			local cvar = GetConVar( data.command )
			if ( cvar ) then
				ctrl:SetDefaultValue( cvar:GetDefault() )
			end
		end

		return ctrl

	end

	if ( control == "propselect" ) then

		local ctrl = vgui.Create( "PropSelect", pnl )
		ctrl:ControlValues( pnl, data ) -- Yack.
		self:AddPanel( pnl, ctrl )
		return ctrl

	end

	if ( control == "matselect" ) then

		local ctrl = vgui.Create( "MatSelect", pnl )
		ctrl:ControlValues( pnl, data ) -- Yack.
		self:AddPanel( pnl, ctrl )

		Derma_Hook( ctrl.List, "Paint", "Paint", "Panel" )

		return ctrl

	end

	if ( control == "ropematerial" ) then

		local ctrl = vgui.Create( "RopeMaterial", pnl )
		ctrl:SetConVar( data.convar )
		self:AddPanel( pnl, ctrl )

		return ctrl

	end

	if ( control == "button" ) then

		local ctrl = vgui.Create( "DButton", pnl )

		-- Note: Buttons created this way use the old method of calling commands,
		-- via LocalPlayer:ConCommand. This way is flawed. This way is legacy.
		-- The new way is to make buttons via controlpanel:Button( name, command, commandarg1, commandarg2 ) etc
		if ( data.command ) then
			function ctrl:DoClick() LocalPlayer():ConCommand( data.command ) end
		end

		ctrl:SetText( data.label or data.text or "No Label" )
		self:AddPanel( pnl, ctrl )
		return ctrl

	end

	if ( control == "numpad" ) then

		local ctrl = vgui.Create( "CtrlNumPad", pnl )
		ctrl:SetConVar1( data.command )
		ctrl:SetConVar2( data.command2 )
		ctrl:SetLabel1( data.label )
		ctrl:SetLabel2( data.label2 )

		self:AddPanel( pnl, ctrl )
		return ctrl

	end

	if ( control == "color" ) then

		local ctrl = vgui.Create( "CtrlColor", pnl )
		ctrl:SetLabel( data.label )
		ctrl:SetConVarR( data.red )
		ctrl:SetConVarG( data.green )
		ctrl:SetConVarB( data.blue )
		ctrl:SetConVarA( data.alpha )

		self:AddPanel( pnl, ctrl )
		return ctrl

	end


	if ( control == "combobox" ) then

		if ( tostring( data.menubutton ) == "1" ) then

			local ctrl = vgui.Create( "ControlPresets", pnl )
			ctrl:SetPreset( data.folder )
			if ( data.options ) then
				for k, v in pairs( data.options ) do
					ctrl:AddOption( k, v )
				end
			end

			if ( data.cvars ) then
				for k, v in pairs( data.cvars ) do
					ctrl:AddConVar( v )
				end
			end

			self:AddPanel( pnl, ctrl )
			return ctrl

		end

		control = "listbox"

	end

	if ( control == "listbox" ) then

		if ( data.height ) then

			local ctrl = vgui.Create( "DListView" )
			ctrl:SetMultiSelect( false )
			ctrl:AddColumn( data.label or "unknown" )

			if ( data.options ) then

				for k, v in pairs( data.options ) do

					local line = ctrl:AddLine( k )
					line.data = v

					-- This is kind of broken because it only checks one convar
					-- instead of all of them. But this is legacy. It will do for now.
					for k, v in pairs( line.data ) do
						if ( GetConVarString( k ) == tostring( v ) ) then
							line:SetSelected( true )
						end
					end

				end

			end

			ctrl:SetTall( data.height )
			ctrl:SortByColumn( 1, false )

			function ctrl:OnRowSelected( LineID, Line )
				for k, v in pairs( Line.data ) do
					RunConsoleCommand( k, v )
				end
			end

			self:AddItem( pnl, ctrl )

			return ctrl

		else

			local ctrl = vgui.Create( "CtrlListBox", pnl )

			if ( data.options ) then
				for k, v in pairs( data.options ) do
					ctrl:AddOption( k, v )
				end
			end

			local left = vgui.Create( "DLabel", pnl )
			left:SetText( data.label )
			left:SetDark( true )
			ctrl:SetHeight( 25 )
			ctrl:Dock( TOP )

			self:AddItem( pnl, left, ctrl )

			return ctrl

		end

	end

	if ( control == "materialgallery" ) then

		local ctrl = vgui.Create( "MatSelect", pnl )
		--ctrl:ControlValues( pnl, data ) -- Yack.

		ctrl:SetItemWidth( data.width or 32 )
		ctrl:SetItemHeight( data.height or 32 )
		ctrl:SetNumRows( data.rows or 4 )
		ctrl:SetConVar( data.convar or nil )

		Derma_Hook( ctrl.List, "Paint", "Paint", "Panel" )

		for name, tab in pairs( data.options ) do

			local mat = tab.material
			local value = tab.value

			tab.material = nil
			tab.value = nil

			ctrl:AddMaterialEx( name, mat, value, tab )

		end

		self:AddPanel( pnl, ctrl )
		return ctrl

	end

	local ctrl = vgui.Create( original, pnl )
	-- Fallback for scripts that relied on the old behaviour
	if ( !ctrl ) then
		ctrl = vgui.Create( control, pnl )
	end
	if ( ctrl ) then

		if ( ctrl.ControlValues ) then
			ctrl:ControlValues( pnl, data )
		end

		self:AddPanel( pnl, ctrl )
		return ctrl

	end

	MsgN( "UNHANDLED CONTROL: ", control )
	PrintTable( data )
	MsgN( "\n\n" )

end