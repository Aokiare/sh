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
            local roleString = ""
            for role in member.roles:iter() do
                roleString = roleString..role.mentionString.." "
            end
            local perms
            if member:hasPermission("administrator") then
                perms = "administrator"
            else
                perms = utils.tableToString(member:getPermissions():toArray())
            end
            message:reply({ embed = {author = {name = member.tag, icon_url = member:getAvatarURL(1024)}, thumbnail = {url = member:getAvatarURL(1024)}, color = member:getColor().value, description = member.user.mentionString, fields = {{name = "joined", value = os.date("%d %b, %Y %I:%M:%S %p", discordia.Date.parseISO(member.joinedAt)), inline = true}, {name = "registered", value = os.date("%d %b, %Y %I:%M:%S %p", member.user.createdAt), inline = true}, {name = "bot", value = tostring(member.user.bot):lower()}, {name = "roles ["..member.roles:count().."]", value = roleString}, {name = "perms", value = perms}}, footer = {text = "ID: "..member.id}}})
        end
    end
}