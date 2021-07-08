-- Licensed under the Open Software License version 3.0

_G.announceJoin = function (member, vc)
    local guild = member.parent
    local channel

    if guild.id == "570279341011894273" then -- my server
        channel = guild:getChannel("832411421915742209") --sh
    elseif guild.id == "745426262662709359" then -- fla7een neek
        channel = guild:getChannel("798591060375896064") --voiceless fla7
    end

    if member.id == client.user.id then return end
    local msg = channel:send({embed = {author = {name = member.tag, icon_url = member:getAvatarURL(1024)}, description ="**"..member.name.."** joined "..vc.name, color = botColor}})
    discordia.Clock():waitFor("",5000)
    msg:delete()
end

_G.announceLeave = function (member, vc)
    local guild = member.parent
    local channel

    if guild.id == "570279341011894273" then -- my server
        channel = guild:getChannel("832411421915742209") --sh
    elseif guild.id == "745426262662709359" then -- fla7een neek
        channel = guild:getChannel("798591060375896064") --voiceless fla7
    end

    if member.id == client.user.id then return end
    local msg = channel:send({embed = {author = {name = member.tag, icon_url = member:getAvatarURL(1024)}, description ="**"..member.name.."** left "..vc.name, color = botColor}})
    discordia.Clock():waitFor("",5000)
    msg:delete()
end

_G.announceUpdate = function (member)
    local guild = member.parent
    local channel

    if guild.id == "570279341011894273" then -- my server
        channel = guild:getChannel("832411421915742209") --sh
    elseif guild.id == "745426262662709359" then -- fla7een neek
        channel = guild:getChannel("798591060375896064") --voiceless fla7
    end

    if member.id == client.user.id then return end
    local msg = channel:send({embed = {author = {name = member.tag, icon_url = member:getAvatarURL(1024)}, description ="**"..member.name.."**'s voice status has been updated", color = botColor}})
    discordia.Clock():waitFor("",5000)
    msg:delete()
end