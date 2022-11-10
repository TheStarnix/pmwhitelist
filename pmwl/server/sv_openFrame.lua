hook.Add( "PlayerSay", "WLPM_MenuOpenCMD", function( ply, text )
	if ( string.lower( text ) == "!pmwl" ) then
		net.Start("WLPM_MenuOpen")
			localWhitelistedPm = sql.QueryRow("SELECT * from wlpm_players WHERE steamid64= '"..ply:SteamID64().."'")
			net.WriteTable(localWhitelistedPm or {})
			if ply:IsAdmin() then
				net.WriteTable(sql.Query("SELECT * from wlpm_players") or {})
				net.WriteTable(sql.Query("SELECT * from wlpm_playermodels") or {})
			end
		net.Send(ply)
	end
end )

net.Receive("WLPM_ModificationPm", function(len, ply)
	if !ply:IsAdmin() then return end
	local isCreateOrDelete = net.ReadBool()
	local path = net.ReadString()
	if isCreateOrDelete then --If the player added a playermodel
		local name = net.ReadString()
		if sql.QueryRow("SELECT * from wlpm_playermodels WHERE path = '".. path .. "'") == nil then
			sql.QueryRow("INSERT INTO wlpm_playermodels VALUES ('"..name.."', '"..path.."')")
			ply:PrintMessage(HUD_PRINTTALK, "Playermodel créé !")
		else
			ply:PrintMessage(HUD_PRINTTALK, "Erreur: Playermodel déjà existant !")
		end
	else
		if sql.QueryRow("SELECT * from wlpm_playermodels WHERE path = '"..path.."'") != nil then
			sql.QueryRow("DELETE FROM wlpm_playermodels WHERE path = '"..path.."'")
			ply:PrintMessage(HUD_PRINTTALK, "Playermodel supprimé !")
		else
			ply:PrintMessage(HUD_PRINTTALK, "Erreur: Playermodel inexistant !")
		end
	end
	
end)

net.Receive("WLPM_ModificationPlayers", function(len, ply)
	if !ply:IsAdmin() then return end
	local targetPly64 = net.ReadString()
	local path = net.ReadString()
	local isAdd = net.ReadBool()

	if isAdd then
		if sql.QueryRow("SELECT * from wlpm_players WHERE steamid64 = '".. targetPly64 .. "'") == nil then
			sql.QueryRow("INSERT INTO wlpm_players VALUES ('"..targetPly64.."', '"..util.TableToJSON({path}).."')")
			ply:PrintMessage(HUD_PRINTTALK, "Joueur whitelisté !")
		else
			data = sql.QueryRow("SELECT * from wlpm_players WHERE steamid64 = '".. targetPly64 .. "'")
			data = util.JSONToTable(data["pm"])
			for k,v in ipairs(data) do
				if v == path then
					ply:PrintMessage(HUD_PRINTTALK, "Joueur déjà WL sur ce PM !")
					return
				end
			end
			table.insert(data, path)
			sql.QueryRow("UPDATE wlpm_players SET pm = '"..util.TableToJSON(data).."' WHERE steamid64 = '".. targetPly64 .. "'")
			ply:PrintMessage(HUD_PRINTTALK, "Joueur WL avec succès !")
		end
	else
		data = sql.QueryRow("SELECT * from wlpm_players WHERE steamid64 = '".. targetPly64 .. "'")
		data = util.JSONToTable(data["pm"])
		for k,v in ipairs(data) do
			if v == path then
				table.remove( data, k)
				ply:PrintMessage(HUD_PRINTTALK, "Whitelist enlevée pour le joueur sur ce PM !")
				sql.QueryRow("UPDATE wlpm_players SET pm = '"..util.TableToJSON(data).."' WHERE steamid64 = '".. targetPly64 .. "'")
				return
			end
		end
	end
	
	
end)

net.Receive("WLPM_WlSet", function(len, ply)
	local path = net.ReadString()
	data = sql.QueryRow("SELECT * from wlpm_players WHERE steamid64 = '".. ply:SteamID64() .. "'")
	data = util.JSONToTable(data["pm"])
	for k,v in ipairs(data) do
		if v == path then
			ply:PrintMessage(HUD_PRINTTALK, "Playermodel mis !")
			ply:SetModel(path)
			return
		end
	end
	ply:PrintMessage(HUD_PRINTTALK, "Erreur: playermodel inexistant/accès refusé !")

end)