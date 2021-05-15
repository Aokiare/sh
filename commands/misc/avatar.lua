return {
    name = 	"avatar",
	description = "return the avatar of a user",
    hidden = false,
	command = function (message)
    local author = message.guild:getMember(message.author.id)
        local avatar, member, color
        if not args then -- if no input return author's avatar
            member = author
            avatar = member:getAvatarURL(1024)
            color = member:getColor().value
        elseif message.mentionedUsers.first then -- if mentioned user return mentioned user avatar
            member = message.guild:getMember(message.mentionedUsers.first.id)
            avatar = member:getAvatarURL(1024)
            color = member:getColor().value
        elseif message.guild:getMember(args) then -- if used member user id return member avatar with highest role color embed
            member = message.guild:getMember(args)
            avatar = member:getAvatarURL(1024)
            color = member:getColor().value
        elseif not message.guild:getMember(args) and client:getUser(args) then -- if used non member id return user avatar
            member = client:getUser(args)
            avatar = member:getAvatarURL(1024)
            color = discordia.Color.fromHex("#a57562").value
        end
        if not avatar or not member or not color then
            message:reply(err)
        else
            message:reply({embed = {author = {name = member.tag, icon_url = avatar}, image = {url = avatar}, color = color;}})
        end
    end
}