local function RespX(x) return x/1920*ScrW() end
local function RespY(y) return y/1080*ScrH() end

function EditWLPM(panelContent, tablePm)

--[[-------------------------------------------------------------------------
MODEL PREVIEW
---------------------------------------------------------------------------]]
	local modelPreview = vgui.Create("DModelPanel", panelContent)
	modelPreview:SetPos(255, 0)
	modelPreview:SetSize(380, 800)
	modelPreview:SetModel("")
	modelPreview:SetFOV(50)

--[[-------------------------------------------------------------------------
LIST OF PLAYER'S WHITELISTED PM.
---------------------------------------------------------------------------]]
	local listPmPlayer = vgui.Create( "DComboBox", panelContent )
	listPmPlayer:SetPos( 22, 70 )
	listPmPlayer:SetSize( 250, 30 )
	listPmPlayer:SetValue( "Liste des PM sous WL" )
	--tostring(listPmPlayer:GetText())

	listPmPlayer.Paint = function(s,w,h)
		surface.SetDrawColor( 255,255,255,255 )
		surface.SetMaterial( Material("starnix/pm_whitelist/frame_combobox.png") )
		surface.DrawTexturedRect( RespX(0), RespY(0), 250, 30)
	end

	listPmPlayer:SetFontInternal("PMWL_FontText")
	listPmPlayer:SetTextColor( Color(255,255,255) )

	if tablePm != {} then
		for k,v in ipairs(tablePm) do
			listPmPlayer:AddChoice(tablePm[k]["name"], tablePm[k]["path"], false)
		end
	end

	function listPmPlayer:OnSelect( index, text, data )
		modelPreview:SetModel(listPmPlayer:GetOptionData(listPmPlayer:GetSelectedID()))

	end
	

	local removeListPmPlayer = vgui.Create( "DImageButton", panelContent )
	removeListPmPlayer:SetPos( 22, 200 )
	removeListPmPlayer:SetImage( "starnix/pm_whitelist/frame_remove.png" )
	removeListPmPlayer:SizeToContents()
	removeListPmPlayer.DoClick = function()
		if listPmPlayer:GetSelected() != nil then
			net.Start("WLPM_ModificationPm")
				net.WriteBool(false)
				net.WriteString(listPmPlayer:GetOptionData(listPmPlayer:GetSelectedID()))
			net.SendToServer()
			panelContent:GetParent():Close()
		end
	end

	local textRemoveButton = vgui.Create("DLabel", removeListPmPlayer)
	textRemoveButton:SetText("Retirer le PM")
	textRemoveButton:SetPos(90, 5)
	textRemoveButton:SetFont("PMWL_FontText")
	textRemoveButton:SetTextColor( Color(255,255,255) )
	textRemoveButton:SizeToContentsX()
--[[-------------------------------------------------------------------------
PM AVAILABLE TO ADD INTO PLAYER'S LIST.
---------------------------------------------------------------------------]]

	-- NAME
	local imageNamePM = vgui.Create("DImage", panelContent)
	imageNamePM:SetPos(580, 70)
	imageNamePM:SetSize(280, 30)
	imageNamePM:SetImage("starnix/pm_whitelist/frame_textentry.png")

	local namePmAdd = vgui.Create( "DTextEntry", panelContent )
	namePmAdd:SetPos( 610, 70 )
	namePmAdd:SetSize( 250, 30 )
	namePmAdd:SetPlaceholderText( "Nom du PM" )
	--tostring(namePmAdd:GetText())
	namePmAdd:SetDrawBackground(false)
	namePmAdd:SetTextColor( Color(127,140,141) )
	namePmAdd:SetFontInternal("PMWL_FontText")

	-- PATH
	local imagePathPM = vgui.Create("DImage", panelContent)
	imagePathPM:SetPos(580, 120)
	imagePathPM:SetSize(280, 30)
	imagePathPM:SetImage("starnix/pm_whitelist/frame_textentry.png")

	local pathPmAdd = vgui.Create( "DTextEntry", panelContent )
	pathPmAdd:SetPos( 610, 120 )
	pathPmAdd:SetSize( 250, 30 )
	pathPmAdd:SetPlaceholderText( "models/starnix/teemo/beemo.mdl" )
	--tostring(pathPmAdd:GetText())
	pathPmAdd:SetDrawBackground(false)
	pathPmAdd:SetTextColor( Color(127,140,141) )
	pathPmAdd:SetFontInternal("PMWL_FontText")

	local addPmPly = vgui.Create( "DImageButton", panelContent )
	addPmPly:SetPos( 610, 200 )
	addPmPly:SetImage( "starnix/pm_whitelist/frame_check.png" )
	addPmPly:SizeToContents()
	addPmPly.DoClick = function()
		if pathPmAdd:GetText() != "" && namePmAdd:GetText() != "" then
			net.Start("WLPM_ModificationPm")
				net.WriteBool(true) -- Creation = true, delete = false
				net.WriteString(pathPmAdd:GetText())
				net.WriteString(namePmAdd:GetText())
			net.SendToServer()
			panelContent:GetParent():Close()
		end
	end

	local textAddButton = vgui.Create("DLabel", addPmPly)
	textAddButton:SetText("Ajouter le PM")
	textAddButton:SetPos(90, 5)
	textAddButton:SetFont("PMWL_FontText")
	textAddButton:SetTextColor( Color(255,255,255) )
	textAddButton:SizeToContentsX()

end