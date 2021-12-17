-- Licensed under the Open Software License version 3.0

return {
    name = "leave",
    description = "leaves the guild",
    hidden = true,
    command = function (message)
        if message.author ~= owner then message:addReaction("🤡") return end
        message:reply("u sure?")
        local res = client:waitFor("messageCreate", 20000, function(msg)
            if msg.author == owner then
                if msg.content:lower() == "yes" or msg.content:lower() == "y" then
                    return true
                else
                    return false
                end
            end
        end)
        if res == true then
            message:reply("aight im headin out")
            message.guild:leave()
        else
            message:reply("nvm")
        end
    end
}