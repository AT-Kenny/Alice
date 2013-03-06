
--all AT-specific code goes in here

hook.Add("InitPostEntity","SetHostname",function()
    local adj={"Sleepy","Sandy","Senile","Sinful","Soiled","Sarcastic","Sorry","Sadistic","Satanic","Sleek","Spiffy","Symbolic","Spitting","Smooth","Snarky","Saucy","Shameful","Sunny","Shaken","Sexy","Sore","Soaring","Spectacular","Snoring","Silly","Stupid","Soothing","Scorching","Slutty","Sloppy","Slappy","Sexual","Soapy","Sweet","Steamy","Sabbatical","Sugary","Sassy","Solo","Social","Special","Sad","Safe","Shaggy","Soggy","Sly","Slow","Spicy","Squeaky","Scientific","Splendid","Slippery","Stretchable","Slimy","Sacred","Salty","Sultry","Secret","Shameless","Shiny","Speedy","Single","Singles","Sleepless","Sociable","Synonymous","Strange","Systematic","Superior","Spunky","Safety","Simulated","Snappy","Sweaty","Scissoring"}
    --game.ConsoleCommand("hostname Alice's "..table.Random(adj).." Sandbox\n")
    game.ConsoleCommand("hostname Alice's Spam-Proof Sandbox\n")
end)

--server will be password-protected if Alice breaks
hook.Add("InitPostEntity","RemovePassword",function()
    game.ConsoleCommand("sv_password \"\"\n")
end)


--allow guns until someone says "stop"
	--players should spawn with guns
	--run loadout function on players when disabling guns

--/me chat command


hook.Add("PlayerShouldTakeDamage","SuicideCrowbar",function(victim,attacker)
    if victim:IsPlayer() and attacker:IsPlayer() then
    if attacker:GetActiveWeapon():IsValid() and attacker:GetActiveWeapon():GetClass()=="weapon_crowbar" then
            attacker:Kill()
        end
    end
end)


--hacky fastdl replacement

local urls={}
    
urls["http://www.tangoservers.com/fastdl/garrysmod/"]={}
urls["http://heavy.noxiousnet.com/downloadurl/"]={}
urls["http://pluxel.co.uk/fastdl/"]={}
urls["http://gfs.site.nfoservers.com/server/"]={}
urls["http://tdmcarsford.site.nfoservers.com/server/"]={}
urls["http://kroppweb.site.nfoservers.com/server/"]={}

Alice.fastdl=Alice.LoadTable("fastdl") or urls

hook.Add("InitPostEntity","SetFastDL",function()
    local map=game.GetMap()

    local notfound=true

    game.ConsoleCommand("sv_downloadurl \"\"\n")
    if map=="gm_flatgrass" or map =="gm_construct" then return end

    print("setting fastdl url")
    for k,v in pairs(Alice.fastdl) do
        --check if we've already found the map
        for _,m in pairs(v) do
            if m==map then
                print("setting fastdl to "..k)
                notfound=false
                game.ConsoleCommand("sv_downloadurl \""..k.."\"\n")
                return
            end
        end
    end

    --map wasn't found. search each url for it.
    for k,v in pairs(Alice.fastdl) do
        if notfound then
            http.Fetch(k.."maps",function(content)
                if notfound then
                print("searching "..k.."maps for "..map)
                    if content:match("a href=\"("..map.."%.bsp)\"") or content:match("a href=\"("..map.."%.bsp%.bz2)\"") then
                        table.insert(Alice.fastdl[k],map)
                        Alice.SaveTable(Alice.fastdl,"fastdl")
                        print("setting fastdl to "..k)
                        notfound=false
                        game.ConsoleCommand("sv_downloadurl \""..k.."\"\n")
                        return
                    end
                end
            end,
            function(code)
                print(code)
                if code==404 then
                    print("removing "..k)
                    Alice.fastdl[k]=nil
                    Alice.SaveTable(Alice.fastdl,"fastdl")
                end
            end)
        end
    end
    --print("no fastdl url found")
    --game.ConsoleCommand("changelevel gm_flatgrass\n")
end)

hook.Add("CheckPassword","passtest",function(steam,ip,pass)
    print(pass)
end)

--save e2s
