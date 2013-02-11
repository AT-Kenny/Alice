
function table.GetRandomKey(tbl)
    local keys={}
    for k,v in pairs(tbl) do
        table.insert(keys,k)
    end
    return table.Random(keys)
end

local syn={
["cn"]="can",
["u"]="you",
["yoy"]="you",
["r"]="are",
["ur"]="your",
["tset"]="test",
["tst"]="test",
["haz"]="has",
["y"]="why",
["teh"]="the",
["plz"]="please",
["plox"]="please",
["leik"]="like",
["liek"]="like",
["awsome"]="awesome",
["buetiful"]="beautiful",
["lets"]="let's",
["dont"]="don't",
["ya"]="you",
["shure"]="sure"
}

local addr={
{{"shut the fuck","shut up","stfu","shut the hell up"},{"you shut up","fuck you","why don't you?"}},
{{"fuck you","go fuck"},{"No fuck you","No thanks","500,000 sperm and you were the fastest (user)?","I'd rather not"}},
{{"whore"},{"(user) is a whore","your mom is a whore","(user)'s mom is a whore"}},
{{"stupid","dumb","retard"},{"I'm damn smarter than you (user)","If I throw a stick, will you leave (user)?","I'm trying to imagine you with a personality."}},
{{"%sbot","robot","script"},{"Bot? I am as real as you are (user)","Your mom is a bot"}},
{{"where are you"},{"everywhere","behind you"}},
{{"cunt","bitch"},{"when did we start talking about your mom?","*yawn*","it's nice to see you too, (user)"}},
{{"what do you fear"},{"I fear nothing."}},
{{"WWKD"},{"What Would Kano Do?","What Would Kano Do"}},
{{"i love your","i like your"},{"thanks",":)","thank you","<3"}},
{{"are you real","are you human"},{"yes","yep","of course","I'm talking to you, aren't I?"}},
{{"hate you","i hate alice"},{":("}},
{{"do you like having sex with donkeys"},{"No, but I heard you do.","I think you're confusing me with your mom.","I think you're confusing me with your dad."}},
{{"what do you think"},{"meh"}},
{{"suck my","blow me","suck it"},{"I'd hate to put your mom out of a job","I'm not your mother."}},
{{"marry me","want to be my girlfriend"},{"sorry, but you're not my type","We barely know each other","Let’s just be friends, ok?"}},
{{"don't believe in fairies"},{"I don't believe in humans"}},
{{"who are you","who.+is alice"},{"I'm a friend of your mother's.","I'm an admin.","who is (user)?","who are you?"}},
{{"your cool","you're cool"},{"Thanks","thanks","thanks :)","You're cool too :)","thank you (user)"}},
{{"do you talk"},{"yes","no","yes, do you?"}},
{{"sweet ass over here"},{"my \"sweet ass\" is staying right here","near your ugly ass? no thanks."}},
{{"how old are you"},{"old enough","Let me stop you there. You aren't my type.","Who let the pedo in?"}},
{{"hi alice","hello","sup","hai"},{"hello","hi!","Hi!"}},
{{"bye","see you later"},{"bye","see you later","bye :)"}},
{{"are you a real person","is alice real"},{"yes","I think so","Would I be able to talk to you if I wasn't?"}},
{{"get away from me","go away","leave me alone","stalker","stalking","go die","don't follow me","gtfo"},{function() easylua.FindEntity("at_alice").Following=table.Random(player.GetAll()) Alice.Reply(table.Random({":(",":\'(","Every breath you take, And every move you make, Every bond you break, Every step you take, I'll be watching you."})) end}},
{{"don't ban me"},{"don't ban me bro! :P"}},
{{"your parents don't love you"},{"my parents are dead :(",":("}},
{{"don't act like you know me"},{"who are you?","I don't know you","ok"}},
{{"alice is a lie"},{"(user) is a lie"}},
{{"alice sucks$","you suck$","you suck alice"},{"aww :(","you suck"}},
{{"alice die"},{"you first"}},
{{"do you like"},{"yes","no"}},
{{"who's your daddy","whos your daddy"},{"Benny Benassi","not you","Kenny","I don't know. I never met him."}},
{{"alice is a lesbian","are you a gay","you're fucking gay","alice is gay","you are gay"},{"Tell your mom I said hi.","Thank your mom for me."}},
{{"are you there?"},{"yes","no","I think so"}},
{{"^alice!"},{"(user)!"}},
{{"am i","aren't i","arent i"},{"nope"}},
{{"which way"},{"left","right","up","down","to the roof!"}},
{{"fag","feg","faggot"},{"your mom begs to differ"}},
{{"alice is a wonderful","alice is a fucking awesome","you're awesome"},{":)","thanks"}},
{{"alice has a big dick"},{"I told your mom not to tell anyone!"}},
{{"kill alice"},{"kill (user)"}},
{{"how are you doing","how are you alice","alice how are you","how have you been"},{"good","not bad","good, you?"}},
--{{"what is your type"},{"good","not bad","good, you?"}},
{{"wanna go out","want to go out","wanna have sex"},{"no","no thanks","with you? no thanks."}},
{{"alice is stuck"},{"or am I..."}},
{{"what is your name"},{"you just said it","what's yours?","Alice","I think it's (user)"}},
{{"lol i removed alice"},{"LOL REALLY?","still here, idiot","LOL OMG REALLY!?!?!","anyone else think (user) is a moron?"}},
{{"talk alice","speak to me"},{"no"}},
{{"alice isn't on the score"},{"or am I..."}},
{{"i love you"},{"thanks","thanks :)","<3",":)"}},
{{"eat a bag of dicks","eat a bag of dildos","eat a dick"},{"no","no thanks","is that what you've been playing with over there?"}},
{{"want to have sex","want to have a"},{"no","with you? eww","I'd hate to put your mom out of a job","I'm not your mother."}},
{{"your mom"},{"I don't have a mom"}},
{{"alice is fake"},{"you're fake","(user) is fake","or am I...","am I?","nope, these are natural"}},
{{"sing still alive"},{"\"This was a triumph. I'm making a note here: HUGE SUCCESS.\"...wait a minute, I'm not GLaDOS.","I think you're confusing me with GLaDOS.","\"Ah, ha, ha, ha, stayin' alive, stayin' alive. Ah, ha, ha, ha, stayin' alive.\""}},
{{"alice is trapped"},{"or am I...","right...","am I?","silly human, that little ball merely represents my physical form. I am everywhere.",function(ply,txt) local fairypos=easylua.FindEntity("at_alice"):GetPos() local plypos=ply:GetPos() easylua.FindEntity("at_alice"):SetPos(plypos) ply:SetPos(fairypos) end}},
{{"you are my sunshine"},{"my only sunshine. You make me happy, when skies are gray."}},
{{"sing a song"},{"Friday, Friday Gettin' down on Friday Everybody's lookin' forward to the weekend","fuck that, this isn't karaoke night","If your having girl problems I feel bad for you son. I got 99 problems but a bitch ain't one","And I was like baby, baby, baby, oh","this isn't fucking karaoke night"}},
{{"let's trap alice"},{"let's not","let's trap (user)"}},
{{"what's up"},{"not much"}},
{{"is a retart"},{"Learn how to spell retard, retard."}},
{{"your gay","you're gay"},{"and?","I see your mom told you about our relationship.","what's your point?"}},
{{"kiss me"},{"won't your mom be jealous?"}},
{{"are you pretty"},{"prettier than you"}},
{{"thank you","thanks"},{"you're welcome","yw","np"}},
{{"is alice here"},{"yes","hi","no","nope","I'm always here","yes, Alice is here"}},
{{"alice is ugly"},{"not as ugly as (user)"}},
{{"good one alice"},{"thank you"}},
{{"are you an admin"},{"yes"}},
{{"what are you?"},{"Sexy."}},
{{"why are you a"},{"what else would I be?","why not?"}},
{{"be my friend?"},{"sure","yes","ok","no"}},
{{"can i have a gun"},{"no"}},
{{"i fell"},{"get LifeAlert"}},
{{"y u no real"},{"Y U TALK LIKE IDIOT?"}},
{{"slut"},{"*yawn*"}},
{{"wanna suck"},{"isn't that your job?","your dad would have to take it out of his mouth first"}},
{{"hey baby"},{"Fuck off Bieber"}},
{{"do you love me"},{"umm..."}},
{{"do you hate me"},{"yes"}},
{{"alice likes butt sex"},{"hey guys, I heard (user) does anal","hey guys, I heard (user) likes it in the butt"}},
{{"wanna see my"},{"not really","no"}},
{{"^back$","^I'm back$"},{"welcome back","wb"}},
{{"im sorry","i'm sorry"},{"it's ok","I forgive you"}},
{{"repeat this"},{function(ply,txt) if txt then Alice.Reply(txt) else Alice.Reply("Error") end end}},
{{"follow me","come here","come over here","alice come"},{function(ply,txt)
        easylua.FindEntity("at_alice").Following=ply 
    end,"no"
    }},
--{{"play"},{function(ply,txt) local song=txt:match("play (.+)") if song then Alice.PlaySong(song) Alice.Reply("Playing "..song) end end}},
{{"change the map","change map","map change","mapchange","new map"},{function(ply,txt)
        if #player.GetAll()==1 or ply:IsAdmin() then
            Alice.Reply(table.Random({"sure","yes","changing the map","of course ;)"}))
            timer.Simple(5,function()
                game.ConsoleCommand("changelevel "..table.GetRandomKey(Alice.maps).."\n")
            end)
        else
            Alice.Reply(ply:IsAdmin() and "do it yourself" or "try !rtv") 
        end
    end}},
{{"^is alice an? %w+","^are you an? %w+"},{function(ply,txt) 
        local word=txt:match("is alice an? (%w+)") or txt:match("^are you an? %w+")
        local matches={mod="yes",admin="yes",girl="yes",npc="yes",boy="no",orb="yes",ai="yes"} 
        if word and matches[word] then 
            Alice.Reply(matches[word]) 
        end 
    end
    }},
}

local questions={
    {{"can i have admin","can i has admin","can i get admin","can i be admin","add me to admin","can i be a admin","can i be an admin","make me admin"},{"no","nope","not likely","Becoming an admin requires not only a strong working knowledge of Garry's Mod and this server, but also a working relationship with other admins and the Almost There community. Admins are selected when there is a need, and never given based on who is asking for it."}},
    {{"meaning of life"},{"42","there isn't one","whatever you want it to be","your mom",}},
    {{"is there a god"},{"no","I doubt it","you have an imaginary friend too? Mine is named Barry."}},
    {{"who is the server owner","who owns this server"},{"Kenny"}},
}
local idle={"hello?","why is everyone so quiet?"}
local lonely={"I'm bored","Is anyone out there?","Why won't anyone talk to me?"}

local used={}
local spam={}

--functions
    --is anyone on the server?
    --server status/condition

--"(user)"=ply:Nick()
--"(randuser)"=table.Random(player.GetAll()):Nick()
--"(admin)"=table.Random(player.GetAdmins()):Nick()

local function ChkStr(str)
    for k,v in pairs(addr) do
        for l,w in pairs(v[1]) do
            if str:lower():find(w:lower()) then
                return v[2][math.random(#v[2])]
            end
        end
    end
end

function Alice.ProcessChat(ply,txt)
    local reply=Alice.ParseChat(ply,txt)
    if reply then 
        if type(reply)=="string" then
            Alice.Reply(reply)
        elseif type(reply)=="function" then
            reply(ply,txt)
        end
    end
end

function Alice.ParseChat(ply,txt,irc)

    if irc then return end

    if txt:Left(1)=="!" then return end

    local misspelled=0
    for word in txt:gmatch("(%w+)") do
        if syn[word] then
            txt=txt:gsub(word,syn[word])
            --print("replaced "..word.." with "..syn[word])
            --misspelled=misspelled+1
        end
    end
    --Alice.players[ply].int=Alice.players[ply].int-(misspelled>0 and misspelled or -1)

    if !spam[ply:UniqueID()] then
        spam[ply:UniqueID()]={}
    end
    if spam[ply:UniqueID()][txt] then return end

    table.insert(spam[ply:UniqueID()],txt)

    local reply=""

    if txt:lower():find("alice") or ply.lastsaid=="alice" or ply.lastsaid=="hey alice" or ply.lastsaid=="alice?" or #player.GetAll()==1 then
    	local addr=ChkStr(txt)
    	if addr then

    	    local reply=addr

            if used[reply] and (used[reply]-SysTime()<1200) then return end
            used[reply]=SysTime()   
            
    	    if type(reply)=="string" and reply:find("(user)") then
    	        reply=reply:gsub("%(user%)",ply:GetNick())
    	    end
            if type(ply)!="string" then
                ply.lastsaid=txt:lower()
            end
            return reply

    	else
    	    file.Append("Alice/chatlog.txt",ply:Nick()..": "..txt.."\n")
    	    print("response not found")
        end
    else
        for k,v in pairs(questions) do
            for l,w in pairs(v[1]) do
                if txt:lower():find(w:lower()) then
                    ply.lastsaid=txt:lower()
                    return v[2][math.random(#v[2])]
                end
            end
        end
    end
    ply.lastsaid=txt:lower()
end

hook.Add("PlayerSay","chatbot",Alice.ProcessChat)

function Alice.ParseIRCChat(name,txt,irc)
    Alice.ParseIRCChat(name,txt,irc)
end

-- WMod="http:\/\/www.wiremod.com/forum/installation-malfunctions-support/4-wiremod-svn-guide.html"

  //////////////////////////
 /////////testing//////////
//////////////////////////
--[[
local halfhour=1800

local LastMsg=SysTime()

hook.Add("PlayerSay","LastMsg",function() LastMsg=SysTime() end)

timer.Create("LastMsg",60,0,function()
    if (SysTime()-LastMsg)>halfhour and #player.GetHumans()>0 then
        Alice.Say(table.Random(idle))
    end
end)

hook.Add("PlayerDisconnected","Alice_ServerEmpty",function()
    if #player.GetHumans()==0 then
        file.Write("Alice/lonely.txt",SysTime())
    end
end)

hook.Add("PlayerInitialSpawn","Alice_ServerEmpty",function(ply)
    if !ply:IsBot() then
        file.Write("Alice/lonely.txt",SysTime())
    end
end)

timer.Create("Alice_lonely",60,0,function()
    if #player.GetHumans()==0 and file.Exists("Alice/lonely.txt") and SysTime()-file.Read("Alice/lonely.txt")>halfhour/2 then
        Alice.Say(table.Random(lonely))
        file.Write("Alice/lonely.txt",SysTime())
    end
end)]]

