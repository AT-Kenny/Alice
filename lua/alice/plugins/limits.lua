--raise default limit if it's hit frequently with no performance loss
--lower limits for spammers
	--timeskickedforspam*percentage to lower

Alice.limits=Alice.LoadTable("limits")

hook.Add("ShutDown","shutdown_savelimits",function()
    Alice.SaveTable(Alice.limits,"limits")
end)

local meta=FindMetaTable("Player")

timer.Simple(1,function()
	function meta:CheckLimit( str )
		print(str)

	    if !Alice.limits[str] then Alice.limits[str]=cvars.Number( "sbox_max"..str, 0 ) end
	    --local c = Alice.limits[str] and Alice.limits[str] or cvars.Number( "sbox_max"..str, 0 )
	    local c = Alice.limits[str]

	    if ( c < 0 ) or player.GetAll()==1 then return true end
	    if ( self:GetCount( str ) > c-1 ) then self:LimitHit( str ) return false end

	    return true

	end
end)
