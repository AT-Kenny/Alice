--chatbot should find recipient of each message or best guess
    --MostLikelyRecipient()?

local chatmsgs={}
--player,time,message

Alice.words=Alice.LoadTable("words")

hook.Add("ShutDown","shutdown_savewords",function()
    Alice.SaveTable(Alice.words,"words")
end)

concommand.Add("say_alice",function(pl,cmd,args)
    if pl:IsValid() then return end
    --print(type(args))
    newchatbot(pl,table.concat(args," "))
end)

local function MostLikelyRecipient(pl,txt)

    if pl:IsValid() then
        table.insert(chatmsgs,{player=pl:UniqueID(),message=txt,time=SysTime()})
        for k,v in pairs(chatmsgs) do
            if (SysTime()-v.time)>300 then
                chatmsgs[k]=nil
            end
        end
    end

    if #player.GetAll()<=1 then
        --player is alone
        if pl:IsValid() then
            print(pl:GetNick().." --> Alice")
            return "Alice"
        end

    else
        local p={}
        --is player looking at someone?
        local tr=pl:GetEyeTrace()
        if !tr.HitNonWorld then return end
        local ent=tr.Entity

        if ent:IsValid() and ent:IsPlayer() then
            --player is probably talking to ent
            print(pl:GetNick().." --> "..ent:GetNick())
            return ent
        end

        --is player responding to a previous message?
            --check previous messages for player's name
        local lastmsg={}
        for k,v in pairs(chatmsgs) do
            lastmsg=(lastmsg.time and lastmsg.time or 0)>v.time and lastmsg or v
        end
        if lastmsg and lastmsg.player then
            local chatter=player.GetByUniqueID(lastmsg.player)
            if chatter and chatter!=pl and chatter:IsValid() then
                print(pl:GetNick().." --> "..chatter:GetNick())
                return chatter
            end
        end
    end

end

function newchatbot(pl,txt)
    --determine who player is talking to
        --is the server empty?
        --are they looking at someone?
        --did someone say something recently?
            --PlayerCanHearPlayersVoice
                --won't work
                --voice chat needs to be detected on the client
                    --run clientside code on a trusted client
            --chat
        --search logs for conversations when server is empty
        --save the player the msg was meant for

        --txt:lower()
        --check for misspelled words
        --match nouns
        --check patterns
        --search logs
        --search movie subs
        --save txt if no reply found

    --local ignore={"the","a"}
    local p=MostLikelyRecipient(pl,txt)
    
end

hook.Add("PlayerSay","Alice_ChatLearning",newchatbot)