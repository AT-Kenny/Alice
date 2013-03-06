

function Alice.Maintenance()

    --create backups of important files
    if !file.Exists("backups","DATA") then
        file.CreateDir("backups")
    end
    local playerbackup="backups/AA_Players/"..os.date("%m-%d-%y")..".txt"
    local errorlog="backups/errors/"..os.date("%m-%d-%y")..".txt"

    if !file.Exists(playerbackup,"DATA") and aa then
        if !file.Exists("backups/AA_Players","DATA") then
            file.CreateDir("backups/AA_Players")
        end
        print("backing up playerinfo")
        file.Write(playerbackup,util.TableToKeyValues(aa.GetAll()))

        local dir="Alice/backups"
        if !file.Exists(dir,"DATA") then
            file.CreateDir("Alice/backups")
        end

        local datafiles=file.Find("Alice/data/*","DATA")
        if !file.Exists(dir.."/data","DATA") then
            file.CreateDir(dir.."/data")
        end
        for k,v in pairs(datafiles) do
            print("backing up "..v)
            file.Write(dir.."/data/"..v,file.Read("Alice/data/"..v,"DATA"))
        end

        if !file.Exists(dir.."/players","DATA") then
            file.CreateDir(dir.."/players")
        end
        local _,pldirs=file.Find("Alice/players/*","DATA")
        for k,v in pairs(pldirs) do
            if !file.Exists("Alice/backups/players/"..v,"DATA") then
                file.CreateDir("Alice/backups/players/"..v)
            end
            print("backing up "..v)
            file.Write(dir.."/players/"..v.."/playerinfo.txt",file.Read("Alice/players/"..v.."/playerinfo.txt","DATA"))
        end
    end
    file.Write("aa_logs/_latest.txt",file.Read(aa_logfile))

    if aio and !file.Exists(errorlog,"DATA") then
        if !file.Exists("backups/errors","DATA") then
            file.CreateDir("backups/errors")
        end
        if file.Exists("lua_errors_server.txt","GAME") then
            file.Write(errorlog,aio.Read("lua_errors_server.txt"))
            aio.Write("lua_errors_server.txt","")
        end
    end
    
end

hook.Add("Alice_PreMapChange","Alice_backupfiles",Alice.Maintenance)

function table.Compare( tbl1, tbl2 )
    for k, v in pairs( tbl1 ) do
        if ( type(v) == "table" and type(tbl2[k]) == "table" ) then
            if ( !table.Compare( v, tbl2[k] ) ) then return false end
        else
            if ( v != tbl2[k] ) then return false end
        end
    end
    for k, v in pairs( tbl2 ) do
        if ( type(v) == "table" and type(tbl1[k]) == "table" ) then
            if ( !table.Compare( v, tbl1[k] ) ) then return false end
        else
            if ( v != tbl1[k] ) then return false end
        end
    end
    return true
end

--print changes somewhere