return {
    name = "resume",
    description = "resume the stream",
    hidden = false,
    command = function (message)
        local bot = message.guild:getMember(client.user.id)
        if not bot.voiceChannel then return message:reply(err) end
        message:addReaction("✨")
        bot.voiceChannel.connection:resumeStream()
        message:reply({
            embed = {
                color = successColor,
                description = "<:shSuccess:835619376052174848> stream resumed"
            }
        })
    end
}