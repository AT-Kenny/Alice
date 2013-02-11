--keep track of times player is kicked for spam
--track bad groups player is in
--get list of player's friends if player is frequent troublemaker

Alice.players=Alice.LoadTable("players")

hook.Add("ShutDown","shutdown_saveplayers",function()
	Alice.SaveTable(Alice.players,"players")
end)

hook.Add("PlayerInitialSpawn","Alice_PlayerInfo",function(ply)
    local unique=ply:UniqueID()
    if !Alice.players[unique] then
        Alice.players[unique]={}
    end
end)