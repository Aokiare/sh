return {
    name = "play",
    description = "play a song off youtube",
    hidden = false,
    command = function (message)
        if not utils.isLink(args) then
            message:reply("i currently only accept links because i fucking suck :DDD")
        else
            local author = message.guild:getMember(message.author.id)
            local vc
            if not author.voiceChannel and not client.user.voiceChannel then
                local reply = message:reply("join a voice channel first retard")
                discordia.Clock():waitFor("",5000)
                reply:delete()
            return
            elseif client.user.voiceChannel then
                vc = client.user.voiceChannel
            else
                vc = author.voiceChannel
                vc:join()
            end
            if not vc then
                message:reply(err)
            else
                local requested = args
                local url = utils.getStream(requested)

                print('fetching', requested)
                if url then
                    message:addReaction("✨")
                    print('playing', url)
                    message:reply({embed = {color = botColor, description = "now playing "..args}})
                    vc.connection:playFFmpeg(url)
                else
                    message:reply('could not fetch audio.')
                end
            end
        end
    end
}