--TODO
    --chat
        --learn about players and save info to txt file
    --learn to recognize suspicious players
    --recognize server problems and correct them
        --lag
            --game.GetFPS()
    --maps
        --download requested maps
    --internal personalities
    --clean out adv dupe public folder in maintenance function

local function debuglog(txt)
    file.Append("debug.txt",txt.."\n")
end


local meta=FindMetaTable("Player")


local players={}
hook.Add("PlayerConnect","PC_ConnectTime",function(ply,ip)
    players[ip]=SysTime()
end)

hook.Add("PlayerInitialSpawn","PIS_ConnectTime",function(ply)
    if ply:IsBot() then return end
    local connecttime=SysTime()-(players[ply:IPAddress()] or SysTime())
    players[ply:IPAddress()]=nil
    print("[ConnectTime] "..ply:Nick()..": "..connecttime)
end)

--grab player name so we can detect name-changing
hook.Add("PlayerInitialSpawn","GetPlayerName",function(ply)
    ply.name=ply:Nick()
end)

--[[timer.Create("CheckPlayerNames",10,0,function()
    for k,v in pairs(player.GetAll()) do
        if v:Nick()!=v.name then
            v:Kick("name change auto-kick")
        end
    end
end)]]

--admin stuff
--these should be moved somewhere else
function GetAveragePing()
    local totalping=0
    for k,v in pairs(player.GetHumans()) do
        totalping=totalping+v:Ping()
    end
    return (totalping/#player.GetHumans())
end

function CleanupRagdolls()
    for k,v in pairs(ents.FindByClass("prop_ragdoll")) do
        v:Remove()
    end
end

--based on DC remover by Divran
E2Blacklist={"DC_system","Lollercoaster","Heavy Weapon Suit","DC_system_v3.1","Grappling Hook Missile II","Wireman","HK-Drone V2","HK-Drone Missiles","Props Madness"}

timer.Create("RemoveDrunkenCombineCrap",5,0,function()
    local e2s = ents.FindByClass("gmod_wire_expression2")
    for k,v in pairs(e2s) do
        if table.HasValue(E2Blacklist,v.name) then
            local owner = E2Lib.getOwner(v)
            local entities = constraint.GetAllConstrainedEntities(v)
            for k2,v2 in pairs(entities) do
                v2:Remove()
            end
            print(owner:Nick().." tried to spawn "..v.name)
            Alice.Reply(v.name.." is blacklisted on this server.")
        end
    end
end)

function string.Explodex(str,sep)
    return string.Explode(sep,str)
end

function TimeCode(str)
    local start=SysTime()
    RunString(str)
    return SysTime()-start
end


function SetHostname(txt)
    game.ConsoleCommand("hostname "..txt.."\n")
    print("changed hostname to "..txt)
end

function SetSlogan(txt)
    SetHostName(GetConVarString("hostname"):gsub(" - .+","").." - "..txt)
end

--kick lone player if afk for 30 minutes