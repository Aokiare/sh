return {
    name = "nickname",
    description = "change a member's nickname",
    hidden = false,
    command = function (message)
        local author = message.guild:getMember(message.author.id)
        local bot = message.guild:getMember(client.user.id)
        if author:hasPermission("manageNicknames") or author.id == client.owner.id then
            local argsTable = string.split(args," ")
            local member
            if message.mentionedUsers.first then
                member = message.guild:getMember(message.mentionedUsers.first.id)
            elseif message.guild:getMember(argsTable[1]) then
                member = message.guild:getMember(argsTable[1])
            end
            if not member then
                message:reply(err)
            return end
            if author.highestRole.position < member.highestRole.position then
                message:reply("discord says ur a peasent compared to "..member.name.." so no fuk u lol")
            return
            else
                if bot.highestRole.position < member.highestRole.position then
                    message:reply({
                        embed = {
                            description ="<:shError:835619357249241159> **"..member.tag.."** has a higher role than me so i cant do that",
                            color = discordia.Color.fromHex("#EA4445").value
                        }
                    })
                return
                else
                    message:addReaction("✨")
                    if argsTable[2] then
                        member:setNickname(argsTable[2])
                        message:reply({
                            embed = {
                                color = successColor,
                                description = "<:shSuccess:835619376052174848> changed **"..member.tag.."** nickname to **"..argsTable[2].."**"
                            }
                        })
                    else
                        member:setNickname()
                        message:reply({
                            embed = {
                                color = successColor,
                                description = "<:shSuccess:835619376052174848> cleared **"..member.tag.."** nickname"
                            }
                        })
                    end
                end
            end
        end
    end
}