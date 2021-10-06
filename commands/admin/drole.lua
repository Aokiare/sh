-- Licensed under the Open Software License version 3.0

return {
    name = "drole",
    description = "delete a role",
    hidden = false,
    command = function (message)
        local author = message.guild:getMember(message.author.id)
        if not author:hasPermission("manageRoles") or not author.id == client.owner.id  then
            local reply = message:reply("nice try retard")
            discordia.Clock():waitFor("",3000)
            message:delete()
            reply:delete()
        else
            local role
            if message.mentionedRoles.first then
                role = message.mentionedRoles.first
            elseif message.guild:getRole(args) then
                role = message.guild:getRole(args)
            else
                role = message.guild.roles:find(function(r)
                    return r.name == args
                end)
            end

            if not role then
                message:reply(err)
            else
                local rolename = role.name
                message:addReaction("✨")
                role:delete()
                message:reply({
                    embed = {
                        description = successEmote.." deleted **"..rolename.."**",
                        color = successColor
                    }
                })
            end
        end
    end
}