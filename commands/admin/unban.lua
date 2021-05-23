return {
    name = "unban",
    description = "unban a retard",
    hidden = false,
    command = function (message)
        local author = message.guild:getMember(message.author.id)
        if not author:hasPermission("banMembers") or not author.id == client.owner.id  then
            local reply = message:reply("nice try retard")
            discordia.Clock():waitFor("",3000)
            message:delete()
            reply:delete()
        return
        else
            if client:getUser(args) then
                local user = client:getUser(args)
                if not message.guild:getBan(user.id) then
                    message:reply({embed = {description ="<:shError:835619357249241159> **"..user.tag.."** isnt banned", color = discordia.Color.fromHex("#EA4445").value}})
                return
                else
                    message:addReaction("✨")
                    message.guild:unbanUser(user.id)
                    message:reply({embed = {color = successColor, description = "<:shSuccess:835619376052174848> unbanned **"..user.tag.."**"}})
                end
            else
                message:reply(err)
            end
        end
    end
}