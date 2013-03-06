--raise default limit if it's hit frequently with no performance loss
--lower limits for spammers
	--timeskickedforspam*percentage to lower

Alice.limits=Alice.LoadTable("limits")

hook.Add("ShutDown","shutdown_savelimits",function()
    Alice.SaveTable(Alice.limits,"limits")
end)

local meta=FindMetaTable("Player")


function Alice.CheckLimit( pl,str )

    if !Alice.limits[str] then
        local limit=cvars.Number( "sbox_max"..str, 0 )
        
        print("setting "..str.." limit to "..limit)
        Alice.limits[str]=limit
    end
    
    local c = Alice.limits[str]

    if ( c < 0 ) or player.GetAll()==1 then return true end
    if ( pl:GetCount( str ) > c-1 ) then pl:LimitHit( str ) return false end

    return true

end


--borrowed from evolve

timer.Simple( 1, function()
    function GAMEMODE:PlayerSpawnProp( ply, mdl ) return Alice.CheckLimit( ply, "props" ) end
    function GAMEMODE:PlayerSpawnVehicle( ply, mdl ) return Alice.CheckLimit( ply, "vehicles" ) end
    function GAMEMODE:PlayerSpawnNPC( ply, mdl ) return Alice.CheckLimit( ply, "npcs" ) end
    function GAMEMODE:PlayerSpawnEffect( ply, mdl ) return Alice.CheckLimit( ply, "effects" ) end
    function GAMEMODE:PlayerSpawnRagdoll( ply, mdl ) return Alice.CheckLimit( ply, "ragdolls" ) end 
        
    meta.CheckLimit = Alice.CheckLimit
end)