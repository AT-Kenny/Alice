
require( "furryfinder" )
 
local playerMeta = FindMetaTable( "Player" )
if ( !playerMeta ) then return end
 
local badgroups={}
badgroups["103582791430313504"]="poki"--poki
badgroups["103582791432037553"]="pokitraining"--pokitraining
badgroups["103582791432424448"]="CyclonesPlace"--CyclonesPlace
badgroups["103582791432601320"]="The Grieferz"--The Grieferz
badgroups["103582791432325378"]="KKK"--KKK
badgroups["103582791431796237"]="Garrysmods Mafia"--Garrysmods Mafia
badgroups["103582791432602987"]="The Jesus Trolls"--The Jesus Trolls
badgroups["103582791432708325"]="Elite Propkillers"--Elite Propkillers
badgroups["103582791432520444"]="MiIlefiore"--MiIlefiore
badgroups["103582791431951128"]="Divinity PK"--Divinity PK
badgroups["103582791431959783"]="The Forline"--The Forline
badgroups["103582791432147398"]="www.Profit-Bot.com"--www.Profit-Bot.com
badgroups["103582791432742930"]="Atee's Club of Trolls and DDoSers"--Atee's Club of Trolls and DDoSers
badgroups["103582791432052258"]="1337's Mic Spammer Radio"--1337's Mic Spammer Radio
badgroups["103582791432639212"]="Trollers 4 Life"
badgroups["103582791432511407"]="1337 troll clan"
badgroups["103582791432270512"]="Gabbo's Public Build" --possibly hacked, advertising sethhack
badgroups["103582791429631186"]="JackAsses United"
badgroups["103582791429991598"]="myg0t"
badgroups["103582791430495525"]="myg0t_international"

local atgroup="103582791430342520"

local function GetPlayerBySteamID( steamid )
    for _, v in ipairs( player.GetAll() ) do
        if ( v:SteamID() == steamid ) then
            return v
        end
    end
    return nil
end
 
function playerMeta:RequestGroupStatus( group )
    return furryfinder.RequestGroupStatus( self:SteamID(), group )
end
 
function playerMeta:IsGroupMember( group )
    if ( !self.GroupStatus || !self.GroupStatus[ group ] ) then
        return nil -- unknown case, haven't requested yet
    end
     
    return self.GroupStatus[ group ].IsMember
end
 
function playerMeta:IsGroupOfficer( group )
    if ( !self.GroupStatus || !self.GroupStatus[ group ] ) then
        return nil -- unknown case, haven't requested yet
    end
     
    return self.GroupStatus[ group ].IsOfficer
end
 

hook.Add( "PlayerAuthed", "GroupPlayerAuthed", function( ply, steam, uniqueid )
    // request group status here
    for k,v in pairs(badgroups) do
        ply:RequestGroupStatus(k)
    end
    ply:RequestGroupStatus(atgroup)
end )
 
 
hook.Add( "GSGroupStatus", "GMTGroupStatus", function( steamUser, steamGroup, isMember, isOfficer )
 
    local ply = GetPlayerBySteamID( steamUser )
     
    if ( !ply ) then return end
     
    if ( !ply.GroupStatus ) then
        ply.GroupStatus = { }
    end
     
    ply.GroupStatus[ steamGroup ] = 
    {
        Group = steamGroup,
        IsMember = isMember,
        IsOfficer = isOfficer,
    }
     
end )

function CheckGroup(ply)
    local groups=0
    for k,v in pairs(badgroups) do
        if ply:IsGroupMember(k) then
            print(ply:Nick().." is in "..v)
            groups=groups+1
        end
    end
    return groups
end

hook.Add("PlayerInitialSpawn","CheckGroups",function(ply)
    if ply:IsBot() then return end

    timer.Simple(5,function()
        print("checking groups")
        local groups=CheckGroup(ply)
        if groups>0 then
            ply:TakeLevels(groups)
        end
        if ply:IsGroupMember(atgroup) then
            print(ply:Nick().." is a member of Almost There!")
            local adj={"Sleepy","Sandy","Senile","Sinful","Soiled","Sarcastic","Sorry","Sadistic","Satanic","Sleek","Spiffy","Symbolic","Spitting","Smooth","Snarky","Saucy","Shameful","Sunny","Shaken","Sexy","Sore","Soaring","Spectacular","Snoring","Silly","Stupid","Soothing","Scorching","Slutty","Sloppy","Slappy","Sexual","Soapy","Sweet","Steamy","Sabbatical","Sugary","Sassy","Solo","Social","Special","Sad","Safe","Shaggy","Soggy","Sly","Slow","Spicy","Squeaky","Scientific","Splendid","Slippery","Stretchable","Slimy","Sacred","Salty","Sultry","Secret","Shameless","Shiny","Speedy","Single","Singles","Sleepless","Sociable","Synonymous","Strange","Systematic","Superior","Spunky","Safety","Simulated","Snappy","Sweaty","Scissoring"}
            SetHostname("Almost There "..table.Random(adj).." Sandbox")
        end
    end)
end)
