return {
    name = "disconnect",
    description = "leaves the vc",
    hidden = false,
    command = function (message)
        local bot = message.guild:getMember(client.user.id)
        if not bot.voiceChannel then
            local reply = message:reply("im not even in a vc dumbass")
            discordia.Clock():waitFor("",5000)
            reply:delete()
        return
        else
            message:addReaction("✨")
            bot.voiceChannel.connection:close()
            message:reply({embed = {color = successColor, description = "<:shSuccess:835619376052174848> left **"..bot.voiceChannel.name.."**"}})
        end
    end
}