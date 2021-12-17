-- Licensed under the Open Software License version 3.0

return {
    name = "unban",
    description = "unban a retard",
    hidden = false,
    command = function (message)
        local author = message.guild:getMember(message.author.id)
        if not author:hasPermission("banMembers") or not author.id == client.owner.id  then
            local reply = message:reply("nice try retard")
            discordia.Clock():waitFor("",3000)
            message:delete()
            reply:delete()
        return
        else
            if client:getUser(args) then
                local user = client:getUser(args)
                if not message.guild:getBan(user.id) then
                    message:reply({
                        embed = {
                            description = failEmote.." **"..user.mentionString.."** isnt banned",
                            color = failColor
                        }
                    })
                return
                else
                    message.guild:unbanUser(user.id)
                    message:reply({
                        embed = {
                            color = successColor,
                            description = successEmote.." unbanned **"..user.mentionString.."**"
                        }
                    })
                end
            else
                message:reply(err)
            end
        end
    end
}