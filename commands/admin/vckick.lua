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
                message:addReaction("✨")
                member:setVoiceChannel()
                message:reply({embed = {color = successColor, description = "<:shSuccess:835619376052174848> disconnected **"..member.tag.."**"}})
            return
            end
        end
    end
}