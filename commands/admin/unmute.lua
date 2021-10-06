-- Licensed under the Open Software License version 3.0

return {
	name = "unmute",
    description = "unmute someone in vc",
    hidden = false,
    command = function (message)
        local author = message.guild:getMember(message.author.id)
        if not author:hasPermission("muteMembers") or not author.id == owner.id then
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
                message:addReaction("✨")
                member:unmute()
                message:reply({
                    embed = {
                        color = successColor,
                        description = successEmote.." unmuted **"..member.mentionString.."**"
                    }
                })
            return
            end
        end
    end
}