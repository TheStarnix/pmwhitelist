local function RespX(x) return x/1920*ScrW() end
local function RespY(y) return y/1080*ScrH() end

function HomeButton(panelContent, localWhitelistedPm)

	local selectPM = vgui.Create( "DComboBox", panelContent )
	selectPM:SetPos( 315, 30 )
	selectPM:SetSize( 250, 30 )
	selectPM:SetValue( "Sélectionnez le PM souhaité" )

	selectPM.Paint = function(s,w,h)
		surface.SetDrawColor( 255,255,255,255 )
		surface.SetMaterial( Material("starnix/pm_whitelist/frame_combobox.png") )
		surface.DrawTexturedRect( RespX(0), RespY(0), 250, 30)
	end

	selectPM:SetFontInternal("PMWL_FontText")
	selectPM:SetTextColor( Color(255,255,255) )


	local modelPreview = vgui.Create("DModelPanel", panelContent)
	modelPreview:SetPos(255, 100)
	modelPreview:SetSize(380, 500)
	modelPreview:SetModel("")
	modelPreview:SetFOV(50)

	function selectPM:OnSelect( index, text, data )
		modelPreview:SetModel(selectPM:GetSelected())
	end

	local chooseButton = vgui.Create( "DImageButton", panelContent )
	chooseButton:SetPos( 315, 65 )				-- Set position
	-- DermaImageButton:SetSize( 16, 16 )			-- OPTIONAL: Use instead of SizeToContents() if you know/want to fix the size
	chooseButton:SetImage( "starnix/pm_whitelist/frame_combobox.png" )	-- Set the material - relative to /materials/ directory
	chooseButton:SizeToContents()				-- OPTIONAL: Use instead of SetSize if you want to resize automatically ( without stretching )
	chooseButton.DoClick = function()
		if selectPM:GetText() != "Sélectionnez le PM souhaité" then
			net.Start("WLPM_WlSet")
				net.WriteString(selectPM:GetSelected())
			net.SendToServer()
			panelContent:GetParent():Close()
		end
	end
	print("BBBBC")
	print(table.ToString(localWhitelistedPm, "TestAaron", true))
	if localWhitelistedPm != nil && !table.IsEmpty(localWhitelistedPm) then
		for k, v in ipairs(util.JSONToTable(localWhitelistedPm["pm"])) do
			selectPM:AddChoice(v)
		end
		selectPM:SetValue( "Sélectionnez le PM souhaité" )
	end
	

	local textChooseButton = vgui.Create("DLabel", chooseButton)
	textChooseButton:SetText("Prendre ce PM")
	textChooseButton:SizeToContentsX()
	textChooseButton:SetPos(90, 5)
end