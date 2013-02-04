

Alice.maps=Alice.LoadTable("maps")

local Maps=Alice.maps

local function MapInit()
    local map=game.GetMap()
    if !Maps[map] then
        Maps[map]={}
        Maps[map].ents=#ents.FindByClass("*")
    end
    local mapfile="maps/"..map..".bsp"
    Maps[map].lastplayed=os.time()
    Alice.SaveTable(Alice.maps,"maps")
end

hook.Add("InitPostEntity","AliceMapInit",MapInit)

local function ChooseMap()
    local Maplist={}
    for k,v in pairs(Maps) do
        if !file.Exists("maps/"..k..".bsp","GAME") then
            Maps[k]=nil
        elseif k!=game.GetMap() then
            table.insert(Maplist,k)
        end
    end
    return #Maplist>1 and table.Random(Maplist) or game.GetMap()
end

local function ATMapChange()
    if #player.GetHumans()==0 then
        local NewMap=ChooseMap()
        for k,v in pairs(player.GetBots()) do
            v:Kick("")
        end
        Alice.Say("Changing map to "..NewMap)
        game.ConsoleCommand("changelevel "..NewMap.."\n")
    end
end

local function PreMapChange()
    Alice.SaveTable(Alice.maps,"maps")
    --timer to prevent the function from running before the player is disconnected
    timer.Simple(5,function()
        --don't run if player was a bot or server is not empty
        if #player.GetHumans()==0 then
            --run anything that requires an empty server
            hook.Call("Alice_PreMapChange")
            --we need a bot to keep timers running
            if #player.GetBots()==0 then
                game.ConsoleCommand("bot\n")
            end
            
            timer.Create("AliceMapChange",300,1,ATMapChange)
            
            hook.Add("PlayerInitialSpawn","CancelMapChange",function(ply)
                if !ply:IsBot() then 
                    timer.Destroy("AliceMapChange") 
                    for k,v in pairs(player.GetBots()) do
                        v:Kick("")
                    end
                end 
            end)
        end
    end)
end

hook.Add("PlayerDisconnected","ATServerEmpty",PreMapChange)
