-- Licensed under the Open Software License version 3.0

---@diagnostic disable: undefined-field
return {
    name = "crole",
    description = "create a role",
    hidden = false,
    command = function (message)
        local author = message.guild:getMember(message.author.id)
        local server = message.guild
        if not author:hasPermission("manageRoles") or not author.id == client.owner.id  then
            message:reply("nice try retard")
        else
            if string.find(args, ",") then
                local argsTable = string.split(args,",") -- name, hex color, hoisted, mentioned
                if string.trim(argsTable[1]) then
                    message:addReaction("✨")
                    local role = server:createRole(string.trim(argsTable[1]))
                    if string.trim(argsTable[2]) and utils.isHex(string.trim(argsTable[2])) then
                        role:setColor(discordia.Color.fromHex(string.trim(argsTable[2])))
                    end
                    if argsTable[3] then
                        if string.trim(argsTable[3]) == "true" or string.trim(argsTable[3]) == "1" then
                            role:hoist()
                        end
                    end
                    if argsTable[4] then
                        if string.trim(argsTable[4]) == "true" or string.trim(argsTable[4]) == "1" then
                            role:enableMentioning()
                        end
                    end
                    message:reply({
                        embed = {
                            description ="<:shSuccess:835619376052174848> created role **"..role.mentionString.."**",
                            color = discordia.Color.fromHex(string.trim(argsTable[2])).value
                        }
                    })
                end
            elseif not args then
                message:addReaction("✨")
                local role = server:createRole(author.name.." is fucking braindead")
                message:reply({
                    embed = {
                        description ="<:shSuccess:835619376052174848> created role **"..role.mentionString.."**",
                        color = successColor
                    }
                })
            else
                message:addReaction("✨")
                local role = server:createRole(args)
                message:reply({
                    embed = {
                        description ="<:shSuccess:835619376052174848> created role **"..role.mentionString.."**",
                        color = successColor
                    }
                })
            end
        end
    end
}