-- Licensed under the Open Software License version 3.0


client:on("messageCreate", function(message)
    if message.author == owner or message.author == bot then return end

    if message.channel.type == discordia.enums.channelType.private then
        local ownerDM = owner:getPrivateChannel()
        if not message.attachment then
            ownerDM:send({
                embed = {
                    author = {
                        name = message.author.tag,
                        icon_url = message.author:getAvatarURL(1024)
                    },
                    description = message.content,
                    color = botColor
                }
            })
        elseif #message.attachments >= 1 then
            for i = 1, #message.attachments do
                ownerDM:send({
                    embed = {
                        author = {
                            name = message.author.tag,
                            icon_url = message.author:getAvatarURL(1024)
                        },
                        description = message.content,
                        image = {
                            url = message.attachments[i].url
                        },
                        color = botColor
                    }
                })
            end
        end
    end
end)
