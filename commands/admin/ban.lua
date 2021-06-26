return {
    name = "ban",
    description = "bans a retard",
    hidden = false,
    command = function (message)
        local author = message.guild:getMember(message.author.id)

        if message.mentionedUsers.first then --if mentioned
            local member = message.mentionedUsers.first
            if not author:hasPermission("banMembers") or not author.id == client.owner.id then
                local reply = message:reply("nice try retard")
                discordia.Clock():waitFor("",3000)
                message:delete()
                reply:delete()
            else
                message:addReaction("✨")
                for user in message.mentionedUsers:iter() do
                    member = message.guild:getMember(user.id)
                    if author.highestRole.position > member.highestRole.position then
                        member:ban()
                    end
                end
                message:reply({
                    embed = {
                        description ="<:shSuccess:835619376052174848> successfully banned mf(s)",
                        color = successColor
                    }
                })
            end
        elseif client:getUser(args) then
            if not author:hasPermission("banMembers") or not author.id == client.owner.id then
                local reply = message:reply("nice try retard")
                discordia.Clock():waitFor("",3000)
                message:delete()
                reply:delete()
            else
                message:addReaction("✨")
                message.guild:banUser(args)
                message:reply({
                    embed = {
                        description ="<:shSuccess:835619376052174848> successfully banned **"..args.mentionString.."**",
                        color = successColor
                    }
                })
            end
        else
            message:reply(err)
        end
    end
}