-- Licensed under the Open Software License version 3.0

return {
    name = "pause",
    description = "pause the stream",
    hidden = false,
    command = function (message)
        local bot = message.guild:getMember(client.user.id)
        if not bot.voiceChannel then return message:reply(err) end
        bot.voiceChannel.connection:pauseStream()
        message:reply({
            embed = {
                color = successColor,
                description = successEmote.." stream paused"
            }
        })
    end
}