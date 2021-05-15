return {
    name = "quote",
    description = "quote a message",
    hidden = false,
    command = function (message)
        local msg, channel, member, content
        if message.channel:getMessage(args) then
            msg = message.channel:getMessage(args)
            content = msg.content
        elseif args then
            msg = message
            message:delete()
            content = msg.content:gsub("%"..prefix.."quote ","")
        else
            message:reply(err)
            return
        end
        member = msg.member
        channel = msg.guild:getChannel(msg.channel.id)
        message:reply({embed={author = {name = member.tag, icon_url = member:getAvatarURL(1024)}, color = member:getColor().value, description = content, footer = {text = "#"..channel.name.." in "..msg.guild.name.." • "..os.date("%d/%m/%Y, %I:%M:%S %p", msg.createdAt)}}})
    end
}