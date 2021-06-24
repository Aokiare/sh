return {
    name = "quote",
    description = "quote a message",
    hidden = false,
    command = function (message)
        local msg, channel, member, content

        if message.channel:getMessage(args) then
            msg = message.channel:getMessage(args)
            content = msg.content
            channel = msg.guild:getChannel(msg.channel.id)
        else
            for txtchnl in message.guild.textChannels:iter() do
                if txtchnl:getMessage(args) then
                    msg = txtchnl:getMessage(args)
                    content = msg.content
                    channel = txtchnl
                break
                end
            end
            if not msg then
                if args then
                    msg = message
                    message:delete()
                    content = msg.content:gsub("%"..prefix.."quote ","")
                    channel = msg.guild:getChannel(msg.channel.id)
                else
                    message:reply(err)
                return
                end
            end
        end
        member = msg.member
        message:reply({
            embed = {
                author = {
                    name = member.tag,
                    icon_url = member:getAvatarURL(1024)
                },
                color = member:getColor().value,
                description = content,
                footer = {
                    text = "#"..channel.name.." in "..msg.guild.name.." • "..os.date("%d/%m/%Y at %I:%M:%S%p", msg.createdAt + 2 * 60 * 60)
                }
            }
        })
    end
}