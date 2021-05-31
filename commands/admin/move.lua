return {
    name = "move",
    description = "move a member to a vc",
    hidden = false,
    command = function (message)
        local author = message.guild:getMember(message.author.id)
        if not author:hasPermission("moveMembers") or not author.id == owner.id then
            message:reply("nice try retard")
        else
            local argsTable = string.split(args," ")
            local member, vc
            if message.mentionedUsers.first then
                member = message.guild:getMember(message.mentionedUsers.first.id)
            elseif message.guild:getMember(argsTable[1]) then
                member = message.guild:getMember(argsTable[1])
            else
                member = author
            end

            if message.mentionedChannels.first then
                vc = message.guild:getChannel(message.mentionedChannels.first.id)
            elseif message.guild:getChannel(argsTable[2]) then
                vc = message.guild:getChannel(argsTable[2])
            elseif message.guild:getChannel(argsTable[1]) then
                vc = message.guild:getChannel(argsTable[1])
            end

            if not member or not vc or not vc.type == 2 or not member.voiceChannel then
                message:reply(err)
            else
                message:addReaction("✨")
                member:setVoiceChannel(vc.id)
                message:reply({embed = {color = successColor, description = "<:shSuccess:835619376052174848> moved **"..member.tag.."** to "..vc.name}})
            return
            end
        end
    end
}