return {
    name = "rrole",
    description = "remove a role from a member",
    hidden = false,
    command = function (message)
        local author = message.guild:getMember(message.author.id)
        if not author:hasPermission("manageRoles") or not author.id == owner.id then
            local reply = message:reply("nice try retard")
            discordia.Clock():waitFor("",3000)
            message:delete()
            reply:delete()
        else
            local argsTable = string.split(args," ")
            local member, role

            if message.mentionedUsers.first then -- if mentions a member
                member = message.guild:getMember(message.mentionedUsers.first.id)
                if message.mentionedRoles.first then -- if mentions a member and a role
                    role = message.guild:getRole(message.mentionedRoles.first.id)
                elseif message.guild:getRole(argsTable[2]) then -- if mentions a member and uses role id
                    role = message.guild:getRole(argsTable[2])
                end
            elseif message.guild:getMember(argsTable[1]) then -- if uses user id
                member = message.guild:getMember(argsTable[1])
                if message.mentionedRoles.first then -- if uses user id and mentions a role
                    role = message.guild:getRole(message.mentionedRoles.first.id)
                elseif message.guild:getRole(argsTable[2]) then -- if uses user id and role id
                    role = message.guild:getRole(argsTable[2])
                end
            elseif not message.mentionedUsers.first and not message.guild:getMember(argsTable[1]) then
                if message.mentionedRoles.first then
                    member = author
                    role = message.guild:getRole(message.mentionedRoles.first.id)
                elseif message.guild:getRole(argsTable[1]) then
                    member = author
                    role = message.guild:getRole(argsTable[1])
                end
            end
            if not member or not role then
                message:reply(err)
            else
                message:addReaction("✨")
                member:removeRole(role.id)
                message:reply({
                    embed = {
                        description ="<:shSuccess:835619376052174848> removed **"..role.name.."** from **"..member.tag.."**",
                        color = successColor
                    }
                })
            end
        end
    end
}