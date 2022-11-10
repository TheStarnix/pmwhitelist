local function RespX(x) return x/1920*ScrW() end
local function RespY(y) return y/1080*ScrH() end

function InfoButton(panelContent)

	local titleCredits = vgui.Create( "DLabel", panelContent )
	titleCredits:SetPos( 405, 40 )
	titleCredits:SetText( "Crédits:" )
	titleCredits:SetFont("PMWL_FontTitle")
	titleCredits:SizeToContents()

	local credits = {
		"Icons made by Pixel perfect (Flaticon)",
		"Icons made by Freepik (Flaticon)",
		"Icons made by Vectors Market (Flaticon)",
		"Addon created by Starnix"
	}

	local spacePos = 80
	for i = 1, #credits do
		spacePos= spacePos+20
		local creditsLabel = vgui.Create( "DLabel", panelContent )
		creditsLabel:SetPos( 20, spacePos )
		creditsLabel:SetText( credits[i] )
		creditsLabel:SetFont("PMWL_FontText")
		creditsLabel:SizeToContents()
	end
end