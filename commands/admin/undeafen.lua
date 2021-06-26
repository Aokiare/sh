return {
	name = "undeafen",
    description = "undeafen someone in vc",
    hidden = false,
    command = function (message)
        local author = message.guild:getMember(message.author.id)
        if not author:hasPermission("deafenMembers") or not author.id == owner.id then
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
                member:undeafen()
                message:reply({
                    embed = {
                        color = successColor,
                        description = "<:shSuccess:835619376052174848> undeafened **"..member.mentionString.."**"
                    }
                })
            return
            end
        end
    end
}