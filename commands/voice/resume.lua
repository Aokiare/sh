-- Licensed under the Open Software License version 3.0

return {
    name = "resume",
    description = "resume the stream",
    hidden = false,
    command = function(message)
        local bot = message.guild:getMember(client.user.id)
        if not bot.voiceChannel then return message:reply(err) end
        bot.voiceChannel.connection:resumeStream()
        message:reply({
            embed = {
                color = successColor,
                description = successEmote .. " stream resumed"
            }
        })
    end
}
