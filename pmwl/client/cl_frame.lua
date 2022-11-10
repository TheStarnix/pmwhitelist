local function RespX(x) return x/1920*ScrW() end
local function RespY(y) return y/1080*ScrH() end

net.Receive("WLPM_MenuOpen", function()
	local localWhitelistedPm = net.ReadTable()
	local tablePlayers = {}
	local tablePm = {}
	if LocalPlayer():IsAdmin() then
		tablePlayers = net.ReadTable()
		tablePm = net.ReadTable()
	end
	

	local frame = vgui.Create("DFrame")
	frame:SetSize(960, 540)
	frame:Center()
	frame:SetTitle("")
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame:MakePopup()
	frame.Paint = function(s,w,h)
		surface.SetDrawColor( 255,255,255,255 )
		surface.SetMaterial( Material("starnix/pm_whitelist/frame_base.png") )
		surface.DrawTexturedRect( RespX(0), RespY(0), 960, 540)
	end

	local panelOnglets = vgui.Create( "DPanel", frame)
	panelOnglets:SetPos( RespX(0), RespY(54) ) -- Set the position of the panel
	panelOnglets:SetSize( 50, 540 ) -- Set the size of the panel
	panelOnglets.Paint = nil

	local panelContent = vgui.Create( "DPanel", frame)
	panelContent:SetPos( RespX(50), RespY(54) ) -- Set the position of the panel
	panelContent:SetSize( 960, 540 ) -- Set the size of the panel
	panelContent.Paint = nil
--[[-------------------------------------------------------------------------
TAB - EDIT PM. (Add / Delete)
---------------------------------------------------------------------------]]
	if LocalPlayer():IsAdmin() then
		local buttonEditPM = vgui.Create("DImageButton", panelOnglets)
		buttonEditPM:SetPos( 10, 180 )
		buttonEditPM:SetImage("starnix/pm_whitelist/frame_documents.png")
		buttonEditPM:SetColor(Color(197, 220, 241, 255))
		buttonEditPM:SizeToContents()
		buttonEditPM.DoClick = function()
			panelContent:Clear()
			EditWLPM(panelContent, tablePm)
		end
		buttonEditPM.OnCursorEntered = function()
			buttonEditPM:SetColor(Color(255, 255, 255))
		end
		buttonEditPM.OnCursorExited = function()
			buttonEditPM:SetColor(Color(197, 220, 241, 255))
		end
	end
	
--[[-------------------------------------------------------------------------
TAB - ADD WL PLAYER TO A WL PM. (Add / Delete)
---------------------------------------------------------------------------]]
	if LocalPlayer():IsAdmin() then
		local buttonEditPly = vgui.Create("DImageButton", panelOnglets)
		buttonEditPly:SetPos( 12, 100 )
		buttonEditPly:SetImage("starnix/pm_whitelist/frame_edit.png")
		buttonEditPly:SetColor(Color(197, 220, 241, 255))
		buttonEditPly:SizeToContents()
		buttonEditPly.DoClick = function()
			panelContent:Clear()
			EditWLPly(panelContent, tablePm, tablePlayers)
		end
		buttonEditPly.OnCursorEntered = function()
			buttonEditPly:SetColor(Color(255, 255, 255))
		end
		buttonEditPly.OnCursorExited = function()
			buttonEditPly:SetColor(Color(197, 220, 241, 255))
		end
	end
--[[-------------------------------------------------------------------------
TAB - SET A WL PM.
---------------------------------------------------------------------------]]
	local buttonProfile = vgui.Create("DImageButton", panelOnglets)
	buttonProfile:SetPos( 10, 20 )
	buttonProfile:SetImage("starnix/pm_whitelist/frame_home.png")
	buttonProfile:SetColor(Color(197, 220, 241, 255))
	buttonProfile:SizeToContents()
	buttonProfile.DoClick = function()
		panelContent:Clear()
		HomeButton(panelContent, localWhitelistedPm)
	end
	buttonProfile.OnCursorEntered = function()
		buttonProfile:SetColor(Color(255, 255, 255))
	end
	buttonProfile.OnCursorExited = function()
		buttonProfile:SetColor(Color(197, 220, 241, 255))
	end
--[[-------------------------------------------------------------------------
TAB - INFORMATIONS
---------------------------------------------------------------------------]]
	local buttonInfos = vgui.Create("DImageButton", panelOnglets)
	buttonInfos:SetPos( 10, 435 )
	buttonInfos:SetImage("starnix/pm_whitelist/frame_info.png")
	buttonInfos:SetColor(Color(197, 220, 241, 255))
	buttonInfos:SizeToContents()
	buttonInfos.DoClick = function()
		panelContent:Clear()
		InfoButton(panelContent)
	end
	buttonInfos.OnCursorEntered = function()
		buttonInfos:SetColor(Color(255, 255, 255))
	end
	buttonInfos.OnCursorExited = function()
		buttonInfos:SetColor(Color(197, 220, 241, 255))
	end
--[[-------------------------------------------------------------------------
CLOSE PANEL
---------------------------------------------------------------------------]]
	local closeButton = vgui.Create( "DImageButton", frame )
	closeButton:SetPos( 910, 10 )
	closeButton:SetImage("starnix/pm_whitelist/frame_close.png")
	closeButton:SizeToContents()
	closeButton.DoClick = function()
		frame:Close()
	end
	HomeButton(panelContent, localWhitelistedPm)

end)