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

--server will be password-protected if Alice breaks
hook.Add("InitPostEntity","RemovePassword",function()
    game.ConsoleCommand("sv_password \"\"\n")
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


--antispam
    --this needs to be completely rewritten
        --how did it get this messy? 
        --this has to be the worst code I've ever written

    --new antispam
        --event calls +spamcount function and creates timer to call -spamcount
            --function takes +amount argument
        --if spamcount goes over certain amount watch player closer and prevent spawning, tools
        --vehicle spawns must be one second apart


hook.Add("PlayerInitialSpawn","SpamCountSetup",function(ply)
    ply.propspam=0
    ply.toolspam=0
    ply.vehiclespam=SysTime()
    ply.karma=100

    timer.Create(ply:UniqueID().."_DecreaseSpamCount",1,0,function()
        if ply.propspam>0 then
            ply.propspam=ply.propspam-1
        end
        if ply.toolspam>0 then
            ply.toolspam=ply.toolspam-1
        end
    end)

    --this one might need to be rewritten too
    timer.Create(ply:UniqueID().."_Karma",5,0,function()
        ply.karma=math.Clamp(ply.karma+1,-100,100)
        --print(ply:Nick().." "..ply.karma)
        if ply.karma<25 then 
            -- don't kick until we're sure this works right
            ply:Cleanup()
            ply:Kick("[Alice] spam")
            --print("[Karma] "..ply:Nick().." "..ply.karma) 
        end
    end)
end)

hook.Add("PlayerDisconnected","RemoveSpamCount",function(ply)
    timer.Remove(ply:UniqueID().."_DecreaseSpamCount")
    timer.Remove(ply:UniqueID().."_Karma")
end)

function meta:IncreaseSpamCount(type,amt)
    if self[type.."spam"] then
        self[type.."spam"]=self[type.."spam"]+amt
    end
end

hook.Add("PlayerSpawnProp","Alice_PropSpam",function(ply)
    if !ply.pasting then
        ply:IncreaseSpamCount("prop",1)
        if ply.propspam>10 then
            ply.karma=ply.karma-1
            return false
        end
    end
end)

hook.Add("CanTool","Alice_ToolSpam",function(ply,tr,tool)
    --rewrite this one later
    local safetools={"remover","paint","inflator"}
    if table.HasValue(safetools,tool) then return true end

    amt=0
    if tool!="inflator" and tool!="easy_precision" and tool!="precision_align" and tool!="paint" then
        amt=1
    end
    if ply.toolspam>10 then
        ply.karma=ply.karma-1
        return false
    end
    if tool=="ol_stacker" then
        amt=4
    end
    if "adv_duplicator"==tool or "advdupe2"==tool or "tbduplicator"==tool then
        ply.pasting=true
        timer.Simple(30,function() ply.pasting=false end)
    end
    if "duplicator"==tool then
        if !ply.lastdupe then ply.lastdupe=SysTime()-5 end
        if (SysTime()-ply.lastdupe)>0.5 then
            ply.pasting=true
            timer.Simple(1,function() ply.pasting=false end)
        else
            ply:IncreaseSpamCount("tool",1)
            return false
        end
        ply.lastdupe=SysTime()
    end
    if "dynamite"==tool then
        amt=4
    end
    if "rope"==tool then
        if (SysTime()-(ply.lastrope or SysTime()))>0.5 then
            ply:IncreaseSpamCount("tool",3)
            return false
        end
        ply.lastrope=SysTime()
    end
    ply:IncreaseSpamCount("tool",amt)
end)

hook.Add("PlayerSpawnVehicle","Alice_VehicleSpam",function(ply)
    if (SysTime()-ply.vehiclespam)<1 then
        ply.karma=ply.karma-1
        return false
    end
    ply.vehiclespam=SysTime()
end)

hook.Add("PlayerDeath","Alice_Karma",function(v,w,k)
    if k:IsPlayer() and k!=v then
        k.karma=k.karma-(v.karma/10)
    end
end)


function MostLikelySpammer()
    local lowest="none"
    for _,pl in pairs(player.GetAll()) do
        if pl.karma<100 then
            if type(lowest)=="string" then
                lowest=pl
            else
                lowest=(lowest.karma<pl.karma) and lowest or pl
            end
        end
    end
    return lowest
end

local lastping=50

timer.Create("Alice_CheckPing",10,0,function()
    --change this later to check for spike in ping
    --if GetAveragePing()>400 then
    --print(lastping.." "..GetAveragePing())
    if (GetAveragePing()/4)>lastping then
        --print("spam?")
        local spammer=MostLikelySpammer()
        if spammer and type(spammer)!="string" and spammer:IsPlayer() then
            print(spammer:Nick().."("..spammer.karma..")".." might be spamming")
            --[[spammer:Cleanup()
            Alice.Say("Kicking "..spammer:Nick().." for spam.")
            spammer:Kick("spam")]]
        end
    end
    lastping=GetAveragePing()
end)

require("fps")

function table.GetAverage(tbl)
    local sum=0
    for k,v in pairs(tbl) do
        sum=sum+v
    end
    return sum/#tbl
end

local fpstbl={}
local lowfps=0


timer.Create("Alice_CheckFPS",1,0,function()
    local fps=game.GetFPS()

    if fps<20 then
        lowfps=lowfps+1
        print("fps: "..fps)
    else
        lowfps=0
    end

    if lowfps>=10 then
        print("possible spam: "..fps)
        local spammer=MostLikelySpammer()
        if spammer and type(spammer)!="string" and spammer:IsPlayer() then
            spammer:Cleanup()
            Alice.Say("Kicking "..spammer:Nick().." for spam.")
            spammer:Kick("spam")
        else
            game.ConsoleCommand("nadmod_cdp\n")
        end
    end

    table.insert(fpstbl,fps)

    if #fpstbl>60 then
        table.remove(fpstbl,1)
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

function Alice.FixErrors()
    if #Alice.errors>=1 then
        for k,v in pairs(Alice.errors) do
            local luafile=v:match("%w+.lua")
            local linenum,error=v:match(luafile..":(%d+):(.+)")
            local code=file.Read("plugins/"..luafile,"LUA")
            local line=string.Explode("\r\n",code)[tonumber(linenum)]

            file.Write("Alice/brokenplugins/"..luafile:match("(%w+).lua")..".txt",code)
            print(v.."\n"..line)
        end
    else
        print("no errors")
    end
end

function Alice.ParseLogs()
    local log=file.Read("aa_logs/01-08-13/0.txt","DATA")
    local lines=string.Explode("\n",log)
    
    print(#lines)
    for _,line in pairs(lines) do
        if line:match(": .+") then
            print(line)
        end
    end
end

function Alice.FindLogs()
    local function searchdir(txt)
        local files,folders=file.Find(txt.."/*","DATA")

        for k,v in pairs(folders) do
            print("searching "..txt.."/"..v)
            for _,logfile in pairs(searchdir(txt.."/"..v)) do
                local log=file.Read(txt.."/"..v.."/"..logfile,"DATA")
                local lines=string.Explode("\n",log)
    
                print(#lines)
                for _,line in pairs(lines) do
                    if line:match(": .+") then
                        
                    end
                end
            end
        end
        return files
    end

    searchdir("aa_logs")
end

--learn from logs and movie subs

local function stringtochars(str)
    local tbl={}
    for k,v in pairs(str:Explodex("")) do
        table.insert(tbl,string.byte(v))
    end
    return tbl
end

function subtest()
    local subfile=file.Read("subtest.srt","DATA")
    local subs=string.Explode(subfile,string.char(13)..string.char(10))
    --[[for i=1,100 do
        print(string.byte(subfile[i]),subfile[i])
    end]]
    local chartbl=stringtochars(subfile)
    local subs2=""
    for k,v in pairs(chartbl) do
        if v==10 or v==13 then
            subs2=subs2.."\n"
        else
            subs2=subs2..string.char(v)
        end
    end
    subs=subs2:Explodex("\n\n\n\n")
    print(#subs)
    for k,v in pairs(subs) do
        subnum=v:match("%d+")
        print(subnum)
        print(v)
    end
end
