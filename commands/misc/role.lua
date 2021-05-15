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
            message:reply({ embed = {fields = {{name = "name", value = role.name}, {name = "color", value = discordia.Color(role.color):toHex()}, {name = "mention", value = role.mentionString}, {name = "hoisted", value = role.hoisted}, {name = "position", value = role.position}, {name = "mentionable", value = role.mentionable}, {name = "permissions", value = role.permissions}}, color = discordia.Color(role.color).value, footer = {text = "ID: "..role.id.." • Today at "..os.date("%I:%M %p", os.time() + 2 * 60 * 60)}}})
        end
    end
}