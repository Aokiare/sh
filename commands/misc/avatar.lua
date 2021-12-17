-- Licensed under the Open Software License version 3.0

return {
    name = 	"avatar",
	description = "return the avatar of a user",
    hidden = false,
	command = function (message)
        local author = message.guild:getMember(message.author.id)
        local member, color = author, botColor
        if message.mentionedUsers.first then
            member = message.guild:getMember(message.mentionedUsers.first.id)
        elseif message.guild:getMember(args) then
            member = message.guild:getMember(args)
        elseif not message.guild:getMember(args) and client:getUser(args) then
            member = client:getUser(args)
        elseif args then
            member = message.guild.members:find(function(m) return m.name == args or m.tag == args or m.nickname == args end)
        end
        if not member then return message:reply(err) end
        if message.guild:getMember(member.id) then color = member:getColor().value end
        local avatar = member:getAvatarURL(1024)
        message:reply({
            embed = {
                author = {
                    name = member.tag,
                    icon_url = avatar
                },
                image = {
                    url = avatar
                },
                color = color;
            }
        })
    end
}