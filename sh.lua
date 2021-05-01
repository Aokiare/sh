local discordia = require('discordia')
local client = discordia.Client()
local FileReader = require ('fs')
local http = require('coro-http')
discordia.extensions()

local prefix = ">"
-- local botToken = assert(FileReader.readFileSync("./token")) -- token plaintext file
local botToken = os.getenv("botToken") -- replit env

http.createServer("0.0.0.0", 8000) -- replit keep alive

local function startsWith(str, start)
    return str:sub(1, #start) == start
end
local function isNumeric(str)
    return tonumber(str) ~= nil
end
local function isHex(str)
    return startsWith(str, "#") and #str == 7
end
local function isRGB(str)
    return isNumeric(str) and str <= 255
end
local function isDecimal(str)
    return isNumeric(str) and tonumber(str) <= 16777215
end

client:on('ready', function()
    client:setStatus("dnd")
    print(os.date("!%F %T", os.time() + 2 * 60 * 60).." | \027[94m[BOT]\027[0m     | "..client.user.username.." is online!")
end)

client:on('voiceChannelJoin', function(member, vc)
    local guild = member.parent
    local channel

    if guild.id == "570279341011894273" then -- my server
        channel = guild:getChannel("832411421915742209") --sh
    elseif guild.id == "745426262662709359" then -- fla7een neek
        channel = guild:getChannel("798591060375896064") --voiceless fla7
    end

    if member.id == client.user.id then return end
    local msg = channel:send({embed = {author = {name = member.tag, icon_url = member:getAvatarURL(1024)}, description ="**"..member.name.."** joined "..vc.name, color = discordia.Color.fromHex("#a57562").value}})
    discordia.Clock():waitFor("",5000)
    msg:delete()
end)

client:on('voiceChannelLeave', function(member, vc)
    local guild = member.parent
    local channel

    if guild.id == "570279341011894273" then -- my server
        channel = guild:getChannel("832411421915742209") --sh
    elseif guild.id == "745426262662709359" then -- fla7een neek
        channel = guild:getChannel("798591060375896064") --voiceless fla7
    end

    if member.id == client.user.id then return end
    local msg = channel:send({embed = {author = {name = member.tag, icon_url = member:getAvatarURL(1024)}, description ="**"..member.name.."** left "..vc.name, color = discordia.Color.fromHex("#a57562").value}})
    discordia.Clock():waitFor("",5000)
    msg:delete()
end)

client:on('voiceUpdate', function(member)
    local guild = member.parent
    local channel

    if guild.id == "570279341011894273" then -- my server
        channel = guild:getChannel("832411421915742209") --sh
    elseif guild.id == "745426262662709359" then -- fla7een neek
        channel = guild:getChannel("798591060375896064") --voiceless fla7
    end

    if member.id == client.user.id then return end
    local msg = channel:send({embed = {author = {name = member.tag, icon_url = member:getAvatarURL(1024)}, description ="**"..member.name.."**'s voice status has been updated", color = discordia.Color.fromHex("#a57562").value}})
    discordia.Clock():waitFor("",5000)
    msg:delete()
end)

client:on('messageCreate', function(message)
    local err = { embed = {description ="<:shError:835619357249241159> nah something aint right", color = discordia.Color.fromHex("#EA4445").value}}
	local cmd, args = message.content:match("^(%S+)%s+(.+)$")
	cmd = cmd or message.content
    if message.author.bot or message.author == client.user then return end

    if cmd == prefix.."ping" then
        message:reply({embed = {title = "pong", color = discordia.Color.fromHex("#a57562").value;}})
    end

    if cmd == prefix.."avatar" then
        local author = message.guild:getMember(message.author.id)
        local avatar, member, color
        if not args then -- if no input return author's avatar
            member = author
            avatar = member:getAvatarURL(1024)
            color = member:getColor().value
        elseif message.mentionedUsers.first then -- if mentioned user return mentioned user avatar
            member = message.guild:getMember(message.mentionedUsers.first.id)
            avatar = member:getAvatarURL(1024)
            color = member:getColor().value
        elseif message.guild:getMember(args) then -- if used member user id return member avatar with highest role color embed
            member = message.guild:getMember(args)
            avatar = member:getAvatarURL(1024)
            color = member:getColor().value
        elseif not message.guild:getMember(args) and client:getUser(args) then -- if used non member id return user avatar
            member = client:getUser(args)
            avatar = member:getAvatarURL(1024)
            color = discordia.Color.fromHex("#a57562").value
        end
        if not avatar or not member or not color then
            message:reply(err)
        else
            message:reply({embed = {author = {name = member.tag, icon_url = avatar}, image = {url = avatar}, color = color;}})
        end
    end

    if cmd == prefix.."color" then
        local author = message.guild:getMember(message.author.id)
        local decimal, hex, r, g, b, rgb
        if not args then --no input after command, default to highest role color
            decimal = author:getColor().value
            hex = discordia.Color(decimal):toHex()
            r,g,b = discordia.Color(decimal):toRGB()
            rgb = r..", "..g..", "..b
        elseif isHex(args) then -- check if input is a hex
            hex = args:upper()
            decimal = discordia.Color.fromHex(hex).value
            r,g,b = discordia.Color(decimal):toRGB()
            rgb = r..", "..g..", "..b
        elseif string.find(args, ",") then -- basic check if input is rgb
            local rgbTable = string.split(args, ",")
            r,g,b = tonumber(string.trim(rgbTable[1])),tonumber(string.trim(rgbTable[2])),tonumber(string.trim(rgbTable[3]))
            if isRGB(r) and isRGB(g) and isRGB(b) then -- validate input
                rgb = r..", "..g..", "..b
                decimal = discordia.Color.fromRGB(r,g,b).value
                hex = discordia.Color(decimal):toHex()
            end
        elseif isDecimal(args) then -- check if input is decimal
            decimal = tonumber(args)
            hex = discordia.Color(decimal):toHex()
            r,g,b = discordia.Color(decimal):toRGB()
            rgb = r..", "..g..", "..b
        elseif message.mentionedUsers.first then --check if mentions someone, get highest role color
            local member = message.guild:getMember(message.mentionedUsers.first.id)
            decimal = member:getColor().value
            hex = discordia.Color(decimal):toHex()
            r,g,b = discordia.Color(decimal):toRGB()
            rgb = r..", "..g..", "..b
        end
        if not hex or not rgb or not decimal then
            message:reply(err)
        else
            message:reply({embed = {fields = { {name = "Hex", value = hex}, {name = "RGB", value = rgb}, {name = "Decimal", value = decimal}},color = discordia.Color.fromHex(hex).value;}})
        end
    end

    if cmd == prefix.."ban" then
        local author = message.guild:getMember(message.author.id)

        if message.mentionedUsers.first then --if mentioned
            local member = message.mentionedUsers.first
            if not author:hasPermission("banMembers") or not author.id == client.owner.id then
                local reply = message:reply("nice try retard")
                discordia.Clock():waitFor("",3000)
                message:delete()
                reply:delete()
            else
                message:addReaction("✨")
                for user in message.mentionedUsers:iter() do
                    member = message.guild:getMember(user.id)
                    if author.highestRole.position > member.highestRole.position then
                        member:ban()
                    end
                end
                message:reply({ embed = {description ="<:shSuccess:835619376052174848> successfully banned mf(s)", color = discordia.Color.fromHex("#43B581").value}})
            end
        elseif client:getUser(args) then
            if not author:hasPermission("banMembers") or not author.id == client.owner.id then
                local reply = message:reply("nice try retard")
                discordia.Clock():waitFor("",3000)
                message:delete()
                reply:delete()
            else
                message:addReaction("✨")
                message.guild:banUser(args)
                message:reply({ embed = {description ="<:shSuccess:835619376052174848> successfully banned **"..args.tag.."**", color = discordia.Color.fromHex("#43B581").value}})
            end
        else
            message:reply(err)
        end
    end

    if cmd == prefix.."kick" then
        local author = message.guild:getMember(message.author.id)

        if message.mentionedUsers.first then --if mentioned
            local member = message.mentionedUsers.first
            if not author:hasPermission("kickMembers") or not author.id == client.owner.id then
                local reply = message:reply("nice try retard")
                discordia.Clock():waitFor("",3000)
                message:delete()
                reply:delete()
            else
                message:addReaction("✨")
                for user in message.mentionedUsers:iter() do
                    member = message.guild:getMember(user.id)
                    if author.highestRole.position > member.highestRole.position then
                        member:kick()
                    end
                end
                message:reply({ embed = {description ="<:shSuccess:835619376052174848> successfully kicked mf(s)", color = discordia.Color.fromHex("#43B581").value}})
            end
        elseif client:getUser(args) then
            if not author:hasPermission("kickMembers") or not author.id == client.owner.id then
                local reply = message:reply("nice try retard")
                discordia.Clock():waitFor("",3000)
                message:delete()
                reply:delete()
            else
                message:addReaction("✨")
                message.guild:kickUser(args)
                message:reply({ embed = {description ="<:shSuccess:835619376052174848> successfully kicked **"..args.tag.."**", color = discordia.Color.fromHex("#43B581").value}})
            end
        else
            message:reply(err)
        end
    end

    if cmd == prefix.."time" then --command to display my own time in my own timezone
        local author = message.guild:getMember(client.owner.id)
        local time = os.date("!%I:%M:%S %p", os.time() + 2 * 60 * 60)
        local date = os.date("!%d %B %Y", os.time() + 2 * 60 * 60)
        local dayoftheweek = os.date("!%A", os.time() + 2 * 60 * 60)
        message:reply({embed = {author = {name = author.tag, icon_url = author:getAvatarURL()}, fields = {{name = "Time", value = time}, {name = "Date", value = date}, {name = "Day", value = dayoftheweek:upper()}}, thumbnail = {url = "https://i.imgur.com/9Tq1txG.png"},color = discordia.Color.fromHex("#a57562").value;}})
    end

    if cmd == prefix.."clear" or cmd == prefix.."cl" or cmd == prefix.."prune" or cmd == prefix.."purge" then
        local author = message.guild:getMember(message.author.id)
        local channel = message.guild:getChannel(message.channel.id)
        if author:hasPermission("manageMessages") and isNumeric(args) then
            message:delete()
            channel:bulkDelete(message.channel:getMessagesBefore(message.id, args))
            if args == "1" then
                local reply = message:reply({ embed = {description =args.." message was deleted by **"..author.tag.."**", color = discordia.Color.fromHex("#a57562").value}})
                discordia.Clock():waitFor("",3000)
                reply:delete()
            else
                local reply = message:reply({ embed = {description =args.." messages were deleted by **"..author.tag.."**", color = discordia.Color.fromHex("#a57562").value}})
                discordia.Clock():waitFor("",3000)
                reply:delete()
            end
        else
            message:reply("nice try retard")
        end
    end

    if cmd == prefix.."crole" then
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
                    if string.trim(argsTable[2]) and isHex(string.trim(argsTable[2])) then
                        role:setColor(discordia.Color.fromHex(string.trim(argsTable[2])))
                    end
                    if argsTable[3] and string.trim(argsTable[3]) == "true" or string.trim(argsTable[3]) == "1" then
                        role:hoist()
                    end
                    if argsTable[4] and string.trim(argsTable[4]) == "true" or string.trim(argsTable[4]) == "1" then
                        role:enableMentioning()
                    end
                    message:reply({ embed = {description ="<:shSuccess:835619376052174848> created role **"..role.name.."**", color = discordia.Color.fromHex(string.trim(argsTable[2])).value}})
                end
            elseif not args then
                message:addReaction("✨")
                local role = server:createRole(author.name.." is fucking braindead")
                message:reply({ embed = {description ="<:shSuccess:835619376052174848> created role **"..role.name.."**", color = discordia.Color.fromHex("#43B581").value}})
            else
                message:addReaction("✨")
                local role = server:createRole(args)
                message:reply({ embed = {description ="<:shSuccess:835619376052174848> created role **"..role.name.."**", color = discordia.Color.fromHex("#43B581").value}})
            end
        end
    end

    if cmd == prefix.."arole" then
        local author = message.guild:getMember(message.author.id)
        if not author:hasPermission("manageRoles") or not author.id == client.owner.id  then
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
                    role = message.mentionedRoles.first
                elseif message.guild:getRole(argsTable[2]) then -- if mentions a member and uses role id
                    role = message.guild:getRole(argsTable[2])
                end
            elseif message.guild:getMember(argsTable[1]) then -- if uses user id
                member = message.guild:getMember(argsTable[1])
                if message.mentionedRoles.first then -- if uses user id and mentions a role
                    role = message.mentionedRoles.first
                elseif message.guild:getRole(argsTable[2]) then -- if uses user id and role id
                    role = message.guild:getRole(argsTable[2])
                end
            end
            if not member or not role then
                message:reply(err)
            else
                message:addReaction("✨")
                member:addRole(role.id)
                message:reply({ embed = {description ="<:shSuccess:835619376052174848> added **"..role.name.."** to **"..member.tag.."**", color = discordia.Color.fromHex("#43B581").value}})
            end
        end
    end

    if cmd == prefix.."drole" then
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
            end

            if not role then
                message:reply(err)
            else
                local rolename = role.name
                message:addReaction("✨")
                role:delete()
                message:reply({ embed = {description ="<:shSuccess:835619376052174848> deleted **"..rolename.."**", color = discordia.Color.fromHex("#43B581").value}})
            end
        end
    end

    if cmd == prefix.."role" then
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

    if cmd == prefix.."user" or cmd == prefix.."whois" then
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
            message:reply({ embed = {author = {name = member.tag, icon_url = member:getAvatarURL(1024)},thumbnail = {url = member:getAvatarURL(1024)} , color = member:getColor().value, fields = {{name = "tag", value = member.user.mentionString}, {name = "bot", value = member.user.bot}, {name = "avatar", value = "[URL]("..member:getAvatarURL(1024)..")"}, {name = "created", value = os.date("%d %B %Y, %I:%M:%S %p", member.user.createdAt)}}, footer = {text = "ID: "..member.id.." • Today at "..os.date("%I:%M %p", os.time() + 2 * 60 * 60)}}})
        end
    end

    if cmd == prefix.."lain" then
        local author = message.guild:getMember(message.author.id)
        local vc
        if not author.voiceChannel then
            local reply = message:reply("join a voice channel first retard")
            discordia.Clock():waitFor("",5000)
            reply:delete()
        return
        else
            vc = author.voiceChannel
            vc:join()
        end
        if not vc then
            message:reply(err)
        else
            local stream
            if not args then -- if no args play everything playlist
                stream = "everything"
            elseif args == "cafe" then -- play cafe playlist
                stream = args
            elseif args == "cyberia" then -- play cyberia playlist
                stream = args
            elseif args == "swing" then -- play swing playlist
                stream = args
            else -- if args are something else just play everything playlist
                stream = "everything"
            end
            if vc.connection then
                vc.connection:stopStream()
                message:addReaction("✨")
                message:reply({embed = {title =  "lain", color = discordia.Color.fromHex("#a57562").value, description = "now playing **"..stream..[[** playlist
                requested by **]]..author.tag.."**", thumbnail = {url = "https://i.imgur.com/GRN5n7V.gif"}}})
                vc.connection:playFFmpeg("http://lainon.life:8000/"..stream..".mp3")
            end
        end
    end

    if cmd == prefix.."die" or cmd == prefix.."dc" or cmd == prefix.."disconnect" then
        local bot = message.guild:getMember(client.user.id)
        if not bot.voiceChannel then
            local reply = message:reply("are u braindead?")
            discordia.Clock():waitFor("",5000)
            reply:delete()
        return
        else
            message:addReaction("✨")
            bot.voiceChannel.connection:close()
            message:reply({embed = {color = discordia.Color.fromHex("#43B581").value, description = "<:shSuccess:835619376052174848> left "..bot.voiceChannel.name}})
        end
    end

    if cmd == prefix.."pause" then
        local bot = message.guild:getMember(client.user.id)
        if not bot.voiceChannel then
            message:reply(err)
        return
        else
            message:addReaction("✨")
            bot.voiceChannel.connection:pauseStream()
            message:reply({embed = {color = discordia.Color.fromHex("#43B581").value, description = "<:shSuccess:835619376052174848> stream paused"}})
        end
    end

    if cmd == prefix.."resume" then
        local bot = message.guild:getMember(client.user.id)
        if not bot.voiceChannel then
            message:reply(err)
        return
        else
            message:addReaction("✨")
            bot.voiceChannel.connection:resumeStream()
            message:reply({embed = {color = discordia.Color.fromHex("#43B581").value, description = "<:shSuccess:835619376052174848> stream resumed"}})
        end
    end

    if cmd == prefix.."help" then
        message:reply("لأ")
    end

    if cmd == prefix.."leave" then
        if message.author ~= client.owner then return end
        message:addReaction("✨")
        message:reply("aight im headin out")
        message.guild:leave()
    end

    if cmd == prefix.."say" then
        if message.author ~= client.owner then return end
        local msg = args
        local channel = message.channel
        message:delete()
        channel:send(msg)
    end

    if cmd == prefix.."unban" then
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
                    message:reply({embed = {color = discordia.Color.fromHex("#43B581").value, description = "<:shSuccess:835619376052174848> unbanned **"..user.tag.."**"}})
                end
            else
                message:reply(err)
            end
        end
    end

    if cmd == prefix.."nickname" then
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
                    message:reply({embed = {description ="<:shError:835619357249241159> **"..member.tag.."** has a higher role than me so i cant do that", color = discordia.Color.fromHex("#EA4445").value}})
                return
                else
                    message:addReaction("✨")
                    if argsTable[2] then
                        member:setNickname(argsTable[2])
                        message:reply({embed = {color = discordia.Color.fromHex("#43B581").value, description = "<:shSuccess:835619376052174848> set **"..member.tag.."** nickname to **"..argsTable[2].."**"}})
                    else
                        member:setNickname()
                        message:reply({embed = {color = discordia.Color.fromHex("#43B581").value, description = "<:shSuccess:835619376052174848> cleared **"..member.tag.."** nickname"}})
                    end
                end
            end
        end
    end

    if cmd == prefix.."setstatus" then
        if message.author ~= client.owner then message:addReaction("🤡") return end
        if args == "dnd" or args == "idle" or args == "online" or args == "invisible" then client:setStatus(args) return else message:reply(err) return end
    end

    if cmd == prefix.."setgame" then
        if message.author ~= client.owner then message:addReaction("🤡") return end
        if args then client:setStatus(args) else client:setStatus() end
    end

    if cmd == prefix.."quote" then
        local msg, channel, member, avatar, color
        if message.channel:getMessage(args) then
            msg = message.channel:getMessage(args)

            member = msg.member
            channel = msg.guild:getChannel(msg.channel.id)
            avatar = member:getAvatarURL(1024)
            color = member:getColor().value
        else
            message:reply(err)
        return
        end
        message:reply({embed={author = {name = member.tag, icon_url = avatar}, color = color, description = msg.content, footer = {text = "#"..channel.name.." in "..msg.guild.name.." • "..os.date("%d/%m/%Y, %I:%M:%S %p", msg.createdAt)}}})
    end
end)

client:run('Bot '..botToken)