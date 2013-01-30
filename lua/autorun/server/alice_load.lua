Alice={}

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

for k,v in pairs(file.Find("plugins/*.lua","LUA")) do
	local plugin = CompileString(file.Read("plugins/"..v,"LUA"),v,false)

	if type(plugin)!="string" then
		plugin()
		table.insert(Alice.plugins,v)
		print("[Alice] Loaded "..v)
	else 
		print("[Alice] Failed to load "..v)
		print(plugin)
		table.insert(Alice.errors,plugin)
	end
end

function Alice.Say(text)
	chat.AddText(Color(255,32,164),"Alice",Color(255,255,255),": "..text)
    ServerLog("Alice: "..text.."\n")
end

function Alice.Reply(text,func)
	timer.Simple(math.random(1,3),function() 
		Alice.Say(text)
		if func then
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