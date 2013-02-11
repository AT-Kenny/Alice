
--all AT-specific code goes in here

hook.Add("InitPostEntity","SetHostname",function()
    local adj={"Sleepy","Sandy","Senile","Sinful","Soiled","Sarcastic","Sorry","Sadistic","Satanic","Sleek","Spiffy","Symbolic","Spitting","Smooth","Snarky","Saucy","Shameful","Sunny","Shaken","Sexy","Sore","Soaring","Spectacular","Snoring","Silly","Stupid","Soothing","Scorching","Slutty","Sloppy","Slappy","Sexual","Soapy","Sweet","Steamy","Sabbatical","Sugary","Sassy","Solo","Social","Special","Sad","Safe","Shaggy","Soggy","Sly","Slow","Spicy","Squeaky","Scientific","Splendid","Slippery","Stretchable","Slimy","Sacred","Salty","Sultry","Secret","Shameless","Shiny","Speedy","Single","Singles","Sleepless","Sociable","Synonymous","Strange","Systematic","Superior","Spunky","Safety","Simulated","Snappy","Sweaty","Scissoring"}
    game.ConsoleCommand("hostname Alice's "..table.Random(adj).." Sandbox\n")
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
