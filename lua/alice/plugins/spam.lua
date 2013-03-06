--ask hurble about this one
    --kick player or warn admin?
        --kick player if no admin is present?

--if !(require("fps")) then return end
require("fps")

Alice.spam=Alice.LoadTable("spam")

hook.Add("ShutDown","shutdown_savespam",function()
    Alice.SaveTable(Alice.spam,"spam")
end)

local t={}

local function spamanalysis(pl)
	local tbl=t[pl:UniqueID()].propspam
	local props={}

    if tbl then
    	for k,v in pairs(tbl) do
    		local mdl=v.prop
    		if !props[mdl] then
    			props[mdl]=1
            else
                props[mdl]=props[mdl]+1
    		end
    	end
    end
    PrintTable(props)
    table.insert(Alice.spam,{player=pl:SteamID(),props=props,ppm=t[pl:UniqueID()].ppm,tpm=t[pl:UniqueID()].tpm})
end

local function MostLikelySpammer()
	local lowest="none"
    for _,pl in pairs(player.GetAll()) do
    	local ppm=t[pl:UniqueID()].ppm or 0

        if type(lowest)=="string" then
            lowest=pl
        else
            lowest=((t[lowest:UniqueID()].ppm or 0)<(ppm or 0)) and lowest or pl
        end
    end
    return lowest
end

local function MostLikelySpammer2()
    if player.GetHumans()==1 and table.Count(t)==1 then return player.GetHumans()[1] end

    local suspects={}

    for k,v in pairs(t) do
        if SysTime()-v.lastact<30 then
            local ppm=v.ppm or 0
            local tpm=v.tpm or 0

            if ppm>0 and tpm>0 then
                --find spam probability
                    --uniqueid=prob
                --previous spam examples should influence this
                local prob=ppm+tpm/2
                --look into changing this to a tbl containing k & prob
                --suspects[k]=prob
                table.insert(suspects,{steam=player.FindByUniqueID(k),prob=prob})
            end
        end
    end
    --return uniqueid with highest prob
    return table.GetFirstValue(table.sort(suspects,function(a,b) return a.prob<b.prob end))
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
        print("spam2: "..MostLikelySpammer2())
        if spammer and type(spammer)!="string" and spammer:IsPlayer() then
            spammer:Cleanup()
            spamanalysis(spammer)
            Alice.Say("Kicking "..spammer:Nick().." for spam.")
            spammer:Kick("spam")
        else
            print("no spammer found")
            game.ConsoleCommand("nadmod_cdp\n")
        end
    end

    table.insert(fpstbl,fps)

    if #fpstbl>60 then
        table.remove(fpstbl,1)
    end
end)

hook.Add("PlayerInitialSpawn","createspamtbl",function(pl)
    if !t[pl:UniqueID()] then t[pl:UniqueID()]={} end
end)


hook.Add("PlayerSpawnedProp","Alice_PropSpam",function(pl,mdl)
    t[pl:UniqueID()].propspam=t[pl:UniqueID()].propspam or {}
    local proptbl=t[pl:UniqueID()].propspam
    table.insert(proptbl,{time=SysTime(),prop=mdl})

    for k,v in pairs(proptbl) do
        if (SysTime()-v.time)>30 then
            table.remove(proptbl,k)
        end
    end

    t[pl:UniqueID()].ppm=#proptbl*2
    t[pl:UniqueID()].lastact=SysTime()
end)

hook.Add("CanTool","Alice_ToolSpam",function(pl,tool)
    local safetools={"paint","colour","material","nocollide","remover","faceposer","inflator","eyeposer","finger","colmat"}

    if table.HasValue(safetools,tool) then return true end

    t[pl:UniqueID()].toolspam=t[pl:UniqueID()].toolspam or {}
    local tooltbl=t[pl:UniqueID()].toolspam

    for k,v in pairs(tooltbl) do
        if (SysTime()-v.time)>30 then
            table.remove(tooltbl,k)
        end
    end

    t[pl:UniqueID()].tpm=#tooltbl*2
    t[pl:UniqueID()].lastact=SysTime()
end)

--take recently spawned props into account
