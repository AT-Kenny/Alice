

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
        file.Write(playerbackup,util.TableToKeyValues(aa.GetAll()))
        print("backing up playerinfo")
    end
    file.Write("aa_logs/_latest.txt",file.Read(aa_logfile))

    if aio and !file.Exists(errorlog,"DATA") then
        if file.Exists("lua_errors_server.txt","GAME") then
            file.Write(errorlog,aio.Read("lua_errors_server.txt"))
            aio.Write("lua_errors_server.txt","")
        end
    end

end

hook.Add("Alice_PreMapChange","Alice_backupfiles",Alice.Maintenance)