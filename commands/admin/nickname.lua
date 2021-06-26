return {
    name = "nickname",
    description = "change a member's nickname",
    hidden = false,
    command = function (message)
        local author = message.guild:getMember(message.author.id)
        local bot = message.guild:getMember(client.user.id)
        if not author:hasPermission("manageNicknames") or not author.id == client.owner.id then return message:reply(err) end
            local argsTable = string.split(args," ")
            local member, nickname
            if message.mentionedUsers.first then
                member = message.guild:getMember(message.mentionedUsers.first.id)
                nickname = argsTable[2]
            elseif message.guild:getMember(argsTable[1]) then
                member = message.guild:getMember(argsTable[1])
                nickname = argsTable[2]
            else
                member = message.guild:getMember(message.author.id)
                nickname = argsTable[1]
            end
            if not member then return message:reply(err) end
            if author.highestRole.position < member.highestRole.position then return message:reply({
                    embed = {
                        description ="<:shError:835619357249241159> **"..member.mentionString.."** has a higher role than you",
                        color = discordia.Color.fromHex("#EA4445").value
                    }
                })
            end
            if bot.highestRole.position < member.highestRole.position then return message:reply({
                    embed = {
                        description ="<:shError:835619357249241159> **"..member.mentionString.."** has a higher role than me so i cant do that",
                        color = discordia.Color.fromHex("#EA4445").value
                    }
                })
            end
            message:addReaction("✨")
            if nickname then
                member:setNickname(nickname)
                message:reply({
                    embed = {
                        color = successColor,
                        description = "<:shSuccess:835619376052174848> changed **"..member.mentionString.."** nickname to **"..nickname.."**"
                    }
                })
            else
                member:setNickname()
                message:reply({
                    embed = {
                        color = successColor,
                        description = "<:shSuccess:835619376052174848> cleared **"..member.mentionString.."** nickname"
                    }
                })
            end
    end
}