local function RespX(x) return x/1920*ScrW() end
local function RespY(y) return y/1080*ScrH() end

function EditWLPly(panelContent, tablePm, tablePlayers)
	local getPlayer = 0

--[[-------------------------------------------------------------------------
AVATAR
---------------------------------------------------------------------------]]
	local avatar_border = vgui.Create("DImage", panelContent)
	avatar_border:SetPos(315, 125)
	avatar_border:SetSize(250, 250)
	avatar_border:SetImage("starnix/pm_whitelist/frame_avatarborder.png")

	local avatarImage = vgui.Create( "AvatarImage", panelContent )
	avatarImage:SetSize( 128, 128 )
	avatarImage:SetPos( 375, 175 )
	avatarImage:SetPlayer()

	local avatar_name = vgui.Create("DLabel", panelContent)
	avatar_name:SetText("???")
	avatar_name:SetPos(420, 315)
	avatar_name:SetFont("PMWL_FontText")
	avatar_name:SizeToContents()
	avatar_name:SetTextColor( Color(255,255,255) )

--[[-------------------------------------------------------------------------
LIST OF PLAYERS.
---------------------------------------------------------------------------]]
	local listPlayers = vgui.Create( "DComboBox", panelContent )
	listPlayers:SetPos( 315, 30 )
	listPlayers:SetSize( 250, 30 )
	listPlayers:SetValue( "Liste des joueurs ayant été WL" )

	listPlayers.Paint = function(s,w,h)
		surface.SetDrawColor( 255,255,255,255 )
		surface.SetMaterial( Material("starnix/pm_whitelist/frame_combobox.png") )
		surface.DrawTexturedRect( RespX(0), RespY(0), 250, 30)
	end

	for k, v in ipairs(tablePlayers) do
		listPlayers:AddChoice(v["steamid64"])
	end

	local listOnlinePlayers = vgui.Create( "DComboBox", panelContent )
	listOnlinePlayers:SetPos( 315, 65 )
	listOnlinePlayers:SetSize( 250, 30 )
	listOnlinePlayers:SetValue( "Liste des joueurs connectés" )

--[[-------------------------------------------------------------------------
LIST OF PLAYER'S WHITELISTED PM.
---------------------------------------------------------------------------]]
	local listPmPlayer = vgui.Create( "DComboBox", panelContent )
	listPmPlayer:SetPos( 22, 70 )
	listPmPlayer:SetSize( 250, 30 )
	listPmPlayer:SetValue( "Sélectionnez un joueur" )

	listPmPlayer.Paint = function(s,w,h)
		surface.SetDrawColor( 255,255,255,255 )
		surface.SetMaterial( Material("starnix/pm_whitelist/frame_combobox.png") )
		surface.DrawTexturedRect( RespX(0), RespY(0), 250, 30)
	end

	listPmPlayer:SetFontInternal("PMWL_FontText")
	listPmPlayer:SetTextColor( Color(255,255,255) )

	local removeListPmPlayer = vgui.Create( "DImageButton", panelContent )
	removeListPmPlayer:SetPos( 22, 200 )
	removeListPmPlayer:SetImage( "starnix/pm_whitelist/frame_remove.png" )
	removeListPmPlayer:SizeToContents()
	removeListPmPlayer.DoClick = function()
		if listPmPlayer:GetSelected() == nil then return end
		net.Start("WLPM_ModificationPlayers")
			if getPlayer == 1 then
				net.WriteString(listPlayers:GetSelected())
			elseif getPlayer == 2 then
				net.WriteString(listOnlinePlayers:GetOptionData(listOnlinePlayers:GetSelectedID()))
			end
			net.WriteString(listPmPlayer:GetSelected())
			net.WriteBool(false)
		net.SendToServer()
		panelContent:GetParent():Close()
	end

	local textRemoveButton = vgui.Create("DLabel", removeListPmPlayer)
	textRemoveButton:SetText("Retirer l'accès au PM")
	textRemoveButton:SetPos(90, 5)
	textRemoveButton:SetFont("PMWL_FontText")
	textRemoveButton:SetTextColor( Color(255,255,255) )
	textRemoveButton:SizeToContentsX()
--[[-------------------------------------------------------------------------
LIST OF PLAYERS2
---------------------------------------------------------------------------]]

	function listPlayers:OnSelect( index, text, data )
		getPlayer = 1
		steamworks.RequestPlayerInfo( listPlayers:GetSelected(), function( steamName )
			avatar_name:SetText(steamName)
			avatar_name:SizeToContents()
		end )
		avatarImage:SetPlayer( player.GetBySteamID64(listPlayers:GetSelected()) or LocalPlayer(), 128 )
		listPmPlayer:Clear()
		local listPmOfPly = {}
		for k, v in ipairs(tablePlayers) do
			listPmOfPly = util.JSONToTable(v["pm"])
		end
		if listPmOfPly != {} then
			for k,v in ipairs(listPmOfPly) do
				listPmPlayer:AddChoice(v)
			end
		end
		listPmPlayer:SetValue( "Liste des PM du joueur" )
	end

	listPlayers:SetFontInternal("PMWL_FontText")
	listPlayers:SetTextColor( Color(255,255,255) )

	listOnlinePlayers.Paint = function(s,w,h)
		surface.SetDrawColor( 255,255,255,255 )
		surface.SetMaterial( Material("starnix/pm_whitelist/frame_combobox.png") )
		surface.DrawTexturedRect( RespX(0), RespY(0), 250, 30)
	end

	for k, v in ipairs(player.GetAll()) do
	    listOnlinePlayers:AddChoice(v:Nick(), v:SteamID64(), false)
	end

	function listOnlinePlayers:OnSelect( index, text, data )
		getPlayer = 2
		steamworks.RequestPlayerInfo( data, function( steamName )
			avatar_name:SetText(steamName)
			avatar_name:SizeToContents()
		end )
		avatarImage:SetPlayer( nil or player.GetBySteamID64(data), 128 )
		listPmPlayer:Clear()
		local listPmOfPly = {}
		for k, v in ipairs(tablePlayers) do
			listPmOfPly = util.JSONToTable(v["pm"])
		end
		if listPmOfPly != {} then
			for k,v in ipairs(listPmOfPly) do
				listPmPlayer:AddChoice(v)
			end
		end
		listPmPlayer:SetValue( "Liste des PM du joueur" )
	end

	listOnlinePlayers:SetFontInternal("PMWL_FontText")
	listOnlinePlayers:SetTextColor( Color(255,255,255) )
--[[-------------------------------------------------------------------------
PM AVAILABLE TO ADD INTO PLAYER'S LIST.
---------------------------------------------------------------------------]]
	local listPmAdd = vgui.Create( "DComboBox", panelContent )
	listPmAdd:SetPos( 610, 70 )
	listPmAdd:SetSize( 250, 30 )
	listPmAdd:SetValue( "Liste des PM disponibles" )
	--tostring(listPmAdd:GetText())

	listPmAdd.Paint = function(s,w,h)
		surface.SetDrawColor( 255,255,255,255 )
		surface.SetMaterial( Material("starnix/pm_whitelist/frame_combobox.png") )
		surface.DrawTexturedRect( RespX(0), RespY(0), 250, 30)
	end
	if tablePm != {} then
		for k,v in ipairs(tablePm) do
			listPmAdd:AddChoice(tablePm[k]["name"], tablePm[k]["path"], false)
		end
	end

	listPmAdd:SetFontInternal("PMWL_FontText")
	listPmAdd:SetTextColor( Color(255,255,255) )

	local addPmPly = vgui.Create( "DImageButton", panelContent )
	addPmPly:SetPos( 610, 200 )
	addPmPly:SetImage( "starnix/pm_whitelist/frame_check.png" )
	addPmPly:SizeToContents()
	addPmPly.DoClick = function()
		if getPlayer == 0 || listPmAdd:GetSelected() == nil then return end
		net.Start("WLPM_ModificationPlayers")
			if getPlayer == 1 then
				net.WriteString(listPlayers:GetSelected())
			elseif getPlayer == 2 then
				net.WriteString(listOnlinePlayers:GetOptionData(listOnlinePlayers:GetSelectedID()))
			end
			net.WriteString(listPmAdd:GetOptionData(listPmAdd:GetSelectedID()))
			net.WriteBool(true)
		net.SendToServer()
		panelContent:GetParent():Close()
	end

	local textAddButton = vgui.Create("DLabel", addPmPly)
	textAddButton:SetText("Ajouter l'accès au PM")
	textAddButton:SetPos(90, 5)
	textAddButton:SetFont("PMWL_FontText")
	textAddButton:SetTextColor( Color(255,255,255) )
	textAddButton:SizeToContentsX()
end