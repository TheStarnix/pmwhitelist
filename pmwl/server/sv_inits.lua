--NETS DEFINE.
util.AddNetworkString("WLPM_MenuOpen")

util.AddNetworkString("WLPM_ModificationPlayers")
util.AddNetworkString("WLPM_ModificationPm")
util.AddNetworkString("WLPM_WlSet")

--DB CREATE
sql.Query("CREATE TABLE IF NOT EXISTS wlpm_playermodels('name' TEXT NOT NULL, 'path' TEXT NOT NULL);")
sql.Query("CREATE TABLE IF NOT EXISTS wlpm_players('steamid64' TEXT NOT NULL, 'pm' TEXT NOT NULL);")
--util.TableToJSON pour les pm & path