-- Licensed under the Open Software License version 3.0

return {
    name = "clear",
    description = "bulk delete messages",
    hidden = false,
    command = function (message)
        local author = message.guild:getMember(message.author.id)
        local channel = message.guild:getChannel(message.channel.id)
        if author:hasPermission("manageMessages") and utils.isNumeric(args) then
            message:delete()
            channel:bulkDelete(message.channel:getMessagesBefore(message.id, args))
            if args == "1" then
                local reply = message:reply({
                    embed = {
                        description = args.." message was deleted by **"..author.mentionString.."**",
                        color = botColor
                    }
                })
                discordia.Clock():waitFor("",3000)
                reply:delete()
            else
                local reply = message:reply({
                    embed = {
                        description = args.." messages were deleted by **"..author.mentionString.."**",
                        color = botColor
                    }
                })
                discordia.Clock():waitFor("",3000)
                reply:delete()
            end
        else
            message:reply("nice try retard")
        end
    end
}