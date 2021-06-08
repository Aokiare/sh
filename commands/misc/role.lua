return {
    name = "role",
    description = "return info about a role",
    hidden = false,
    command = function (message)
        local role
        if message.mentionedRoles.first then
            role = message.mentionedRoles.first
        elseif message.guild:getRole(args) then
            role = message.guild:getRole(args)
        end
        if not role then
            message:reply(err)
        else
            message:addReaction("✨")
            message:reply({ embed = {fields = {{name = "name", value = role.name, inline = true}, {name = "color", value = discordia.Color(role.color):toHex(), inline = true}, {name = "members", value = role.members:count(), inline = true}, {name = "mention", value = role.mentionString, inline = true}, {name = "hoisted", value = role.hoisted, inline = true}, {name = "mentionable", value = role.mentionable, inline = true}, {name = "position", value = role.position, inline = true}, {name = "perms", value = utils.tableToString(role:getPermissions():toArray()), inline = false}}, color = discordia.Color(role.color).value, footer = {text = "ID: "..role.id.." • Today at "..os.date("%I:%M %p", os.time())}}})
        end
    end
}