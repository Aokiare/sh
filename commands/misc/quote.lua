-- Licensed under the Open Software License version 3.0

return {
    name = "quote",
    description = "quote a message",
    hidden = false,
    command = function(message)
        local msg, channel, member, content

        if message.channel:getMessage(args) then
            msg = message.channel:getMessage(args)
            content = msg.content
            channel = msg.channel
        else
            if not tonumber(args) then
                if args then
                    msg = message
                    message:delete()
                    content = msg.content:gsub("%" .. prefix .. "quote ", "")
                    channel = msg.channel
                end
            else
                for txtchnl in message.guild.textChannels:iter() do
                    if txtchnl:getMessage(args) then
                        msg = txtchnl:getMessage(args)
                        content = msg.content
                        channel = txtchnl
                        break
                    end
                end
                if not msg then return message:reply(err) end
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
                    text = "#" .. channel.name .. " in " .. msg.guild.name
                    -- text = "#"..channel.name.." in "..msg.guild.name.." • "..os.date("%d/%m/%Y at %I:%M:%S%p", msg.createdAt + 2 * 60 * 60)
                },
                timestamp = msg.timestamp
            }
        })
    end
}
