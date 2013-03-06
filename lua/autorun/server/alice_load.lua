
Alice={}

if !file.Exists("Alice","DATA") then
    file.CreateDir("Alice")
    file.CreateDir("Alice/data")
end

include('alice/sv_alice.lua')
include("von.lua")

Alice.errors={}

function Alice.LoadTable(name)
	local filename="Alice/data/"..name..".txt"
    if !file.Exists(filename,"DATA") then
        file.Write(filename,"{}")
    end
    return von.deserialize(file.Read(filename,"DATA"))
end

function Alice.SaveTable(tbl,name)
    file.Write("Alice/data/"..name..".txt",von.serialize(tbl))
end

Alice.plugins={}

for k,v in pairs(file.Find("alice/plugins/*.lua","LUA")) do
	local plugin = CompileString(file.Read("alice/plugins/"..v,"LUA"),v,false)
	if type(plugin)!="string" then
		Alice.plugins[v]=plugin
	else 
		print("[Alice] Failed to load "..v)
		print(plugin)
		table.insert(Alice.errors,plugin)
	end
end

for k,v in pairs(Alice.plugins) do
	v()
	print("[Alice] Loaded "..k)
end

function Alice.Say(text)
	chat.AddText(Color(255,32,164),"Alice",Color(255,255,255),": "..text)
    ServerLog("Alice: "..text.."\n")
end

function Alice.Reply(text,func)
	timer.Simple(math.random(1,3),function() 
		Alice.Say(text)
		if func and type(func)=="function" then
			timer.Simple(math.random(1,3),func)
		end
	end)
end

function Alice.FindPlayer(name)
	for k,v in pairs(player.GetAll()) do
		if string.match(string.lower(v.AliceNick), string.lower(name)) then
			return ply
		end
	end
	return false
end

function player.GetAdmins()
    local admins={}
    for k,v in pairs(player.GetAll()) do
        if v:IsAdmin() then
            table.insert(admins,v)
        end
    end
    return admins
end

--players table
	--use AlmostAdmin save system
		--option to remove old players
			--only remove if file contains no useful data

if !file.Exists("Alice/players","DATA") then
	file.CreateDir("Alice/players")
end

Alice.players={}

local meta=FindMetaTable("Player")

function meta:A_Save()
	if !file.Exists("Alice/players/"..self:SteamID():gsub(":","_"),"DATA") then
		file.CreateDir("Alice/players/"..self:SteamID():gsub(":","_"))
	end
    file.Write("Alice/players/"..self:SteamID():gsub(":","_").."/playerinfo.txt",von.serialize(Alice.players[self:UniqueID()]))
end

function meta:A_Load()
	if file.Exists("Alice/players/"..self:SteamID():gsub(":","_"),"DATA") then
    	Alice.players[self:UniqueID()]=von.deserialize(file.Read("Alice/players/"..self:SteamID():gsub(":","_").."/playerinfo.txt","DATA"))
    else
    	Alice.players[self:UniqueID()]={}
    end
end

hook.Add("PlayerInitialSpawn","Alice_PlayerInfo",function(pl)
	if pl:IsValid() and !pl:IsBot() then
		pl:A_Load()
	end
end)

hook.Add("PlayerDisconnected","Alice_SavePlayerInfo",function(pl)
	if pl:IsValid() and !pl:IsBot() then
		pl:A_Save()
	end
end)

--find changes to tables and display somewhere