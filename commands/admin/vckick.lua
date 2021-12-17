-- Licensed under the Open Software License version 3.0

return {
	name = "vckick",
    description = "disconnect someone from vc",
    hidden = false,
    command = function (message)
        local author = message.guild:getMember(message.author.id)
        if not author:hasPermission("moveMembers") or not author.id == owner.id then
            message:reply("nice try retard")
        else
            local member
            if message.mentionedUsers.first then
                member = message.guild:getMember(message.mentionedUsers.first.id)
            elseif message.guild:getMember(args) then
                member = message.guild:getMember(args)
            else
                member = author
            end

            if not member or not member.voiceChannel then
                message:reply(err)
            else
                member:setVoiceChannel()
                message:reply({
                    embed = {
                        color = successColor,
                        description = successEmote.." disconnected **"..member.mentionString.."**"
                    }
                })
            return
            end
        end
    end
}