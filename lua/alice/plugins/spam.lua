--ask hurble about this one
    --kick player or warn admin?
        --kick player if no admin is present?

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
    table.insert(Alice.spam,{player=pl:SteamID(),props=props,ppm=t[pl:UniqueID()].ppm})
end

local function MostLikelySpammer()
	local lowest="none"
    for _,pl in pairs(player.GetAll()) do
    	local ppm=At[pl:UniqueID()].ppm
        if type(lowest)=="string" then
            lowest=pl
        else
            lowest=((t[lowest:UniqueID()].ppm or 0)<(ppm or 0)) and lowest or pl
        end
    end
    spamanalysis(lowest)
    return lowest
end

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
end)


local fpstbl={}
local lowfps=0

timer.Create("Alice_CheckFPS2",1,0,function()
    local fps=game.GetFPS()

    if fps<20 then
        lowfps=lowfps+1
        --print("fps: "..fps)
    else
        lowfps=0
    end

    if lowfps>=10 then
        print("possible spam(ppm): "..fps)
        local spammer=MostLikelySpammer()
        if spammer and type(spammer)!="string" and spammer:IsPlayer() then
            --spammer:Cleanup()
            --Alice.Say("Kicking "..spammer:Nick().." for spam.")
            --spammer:Kick("spam")
            print("[ppm] found spammer: "..spammer:Nick())
        else
            --game.ConsoleCommand("nadmod_cdp\n")
            print("[ppm] no spammer found")
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