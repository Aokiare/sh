return {
    name = "user",
    description = "reutrn information about a user",
    hidden = false,
    command = function (message)
        local member
        if message.mentionedUsers.first then
            member = message.guild:getMember(message.mentionedUsers.first.id)
        elseif message.guild:getMember(args) then
            member = message.guild:getMember(args)
        end

        if not member then
            message:reply(err)
        else
            message:addReaction("✨")
            message:reply({ embed = {author = {name = member.tag, icon_url = member:getAvatarURL(1024)},thumbnail = {url = member:getAvatarURL(1024)} , color = member:getColor().value, fields = {{name = "tag", value = member.user.mentionString}, {name = "bot", value = member.user.bot}, {name = "avatar", value = "[URL]("..member:getAvatarURL(1024)..")"}, {name = "created", value = os.date("%d %B %Y, %I:%M:%S %p", member.user.createdAt)}}, footer = {text = "ID: "..member.id.." • Today at "..os.date("%I:%M %p", os.time() + 2 * 60 * 60)}}})
        end
    end
}