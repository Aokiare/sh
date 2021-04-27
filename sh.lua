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
        if args == nil then -- if no input return author's avatar
            member = author
            avatar = member:getAvatarURL(1024)
            color = member:getColor().value
        elseif message.mentionedUsers.first ~= nil then -- if mentioned user return mentioned user avatar
            member = message.guild:getMember(message.mentionedUsers.first.id)
            avatar = member:getAvatarURL(1024)
            color = member:getColor().value
        elseif message.guild:getMember(args) ~= nil then -- if used member user id return member avatar with highest role color embed
            member = message.guild:getMember(args)
            avatar = member:getAvatarURL(1024)
            color = member:getColor().value
        elseif message.guild:getMember(args) == nil and client:getUser(args) ~= nil then -- if used non member id return user avatar
            member = client:getUser(args)
            avatar = member:getAvatarURL(1024)
            color = discordia.Color.fromHex("#a57562").value
        end
        if avatar == nil or member == nil or color == nil then
            message:reply(err)
        else
            message:reply({embed = {author = {name = member.tag, icon_url = avatar}, image = {url = avatar}, color = color;}})
        end
    end

    if cmd == prefix.."color" then
        local author = message.guild:getMember(message.author.id)
        local decimal, hex, r, g, b, rgb
        if args == nil then --no input after command, default to highest role color
            decimal = author:getColor().value
            hex = discordia.Color(decimal):toHex()
            r,g,b = discordia.Color(decimal):toRGB()
            rgb = r..", "..g..", "..b
            message:reply({embed = {fields = { {name = "Hex", value = hex}, {name = "RGB", value = rgb}, {name = "Decimal", value = decimal}},color = discordia.Color.fromHex(hex).value;}})
        elseif isHex(args) then -- check if input is a hex
                hex = args:upper()
                decimal = discordia.Color.fromHex(hex).value
                r,g,b = discordia.Color(decimal):toRGB()
                rgb = r..", "..g..", "..b
                message:reply({embed = {fields = { {name = "Hex", value = hex}, {name = "RGB", value = rgb}, {name = "Decimal", value = decimal}},color = discordia.Color.fromHex(hex).value;}})
        elseif string.find(args, ",") ~= nil then -- basic check if input is rgb
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
        elseif message.mentionedUsers.first ~= nil then --check if mentions someone, get highest role color
            local member = message.guild:getMember(message.mentionedUsers.first.id)
            decimal = member:getColor().value
            hex = discordia.Color(decimal):toHex()
            r,g,b = discordia.Color(decimal):toRGB()
            rgb = r..", "..g..", "..b
        end
        if hex == nil or rgb == nil or decimal == nil then
            message:reply(err)
        else
            message:reply({embed = {fields = { {name = "Hex", value = hex}, {name = "RGB", value = rgb}, {name = "Decimal", value = decimal}},color = discordia.Color.fromHex(hex).value;}})
        end
    end

    if cmd == prefix.."ban" then
        local author = message.guild:getMember(message.author.id)

        if message.mentionedUsers.first ~= nil then --if mentioned
            local member = message.mentionedUsers.first
            if not author:hasPermission("banMembers") then
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
        elseif message.guild:getMember(args) ~= nil then
            if not author:hasPermission("banMembers") then
                local reply = message:reply("nice try retard")
                discordia.Clock():waitFor("",3000)
                message:delete()
                reply:delete()
            else
                message:addReaction("✨")
                message.guild:banUser(args)
                message:reply({ embed = {description ="<:shSuccess:835619376052174848> successfully banned a mf", color = discordia.Color.fromHex("#43B581").value}})
            end
        else
            message:reply(err)
        end
    end

    if cmd == prefix.."kick" then
        local author = message.guild:getMember(message.author.id)

        if message.mentionedUsers.first ~= nil then --if mentioned
            local member = message.mentionedUsers.first
            if not author:hasPermission("kickMembers") then
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
        elseif message.guild:getMember(args) ~= nil then
            if not author:hasPermission("kickMembers") then
                local reply = message:reply("nice try retard")
                discordia.Clock():waitFor("",3000)
                message:delete()
                reply:delete()
            else
                message:addReaction("✨")
                message.guild:banUser(args)
                message:reply({ embed = {description ="<:shSuccess:835619376052174848> successfully kicked a mf", color = discordia.Color.fromHex("#43B581").value}})
            end
        else
            message:reply(err)
        end
    end

    if cmd == prefix.."time" then --command to display my own time in my own timezone
        local author = message.guild:getMember(client.owner.id)
        local time = os.date("!%I:%M:%S %p", os.time() + 2 * 60 * 60)
        local date = os.date("!%d %B, %Y", os.time() + 2 * 60 * 60)
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
                local reply = message:reply({ embed = {description =args.." message was deleted by "..author.tag, color = discordia.Color.fromHex("#a57562").value}})
                discordia.Clock():waitFor("",3000)
                reply:delete()
            else
                local reply = message:reply({ embed = {description =args.." messages were deleted by "..author.tag, color = discordia.Color.fromHex("#a57562").value}})
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
        if not author:hasPermission("manageRoles") then
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
            elseif args == nil then
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
        if not author:hasPermission("manageRoles") then
            local reply = message:reply("nice try retard")
            discordia.Clock():waitFor("",3000)
            message:delete()
            reply:delete()
        else
            local argsTable = string.split(args," ")
            local member, role

            if message.mentionedUsers.first ~= nil then -- if mentions a member
                member = message.guild:getMember(message.mentionedUsers.first.id)
                if message.mentionedRoles.first ~= nil then -- if mentions a member and a role
                    role = message.mentionedRoles.first
                elseif message.guild:getRole(argsTable[2]) ~= nil then -- if mentions a member and uses role id
                    role = message.guild:getRole(argsTable[2])
                end
            elseif message.guild:getMember(argsTable[1]) ~= nil then -- if uses user id
                member = message.guild:getMember(argsTable[1])
                if message.mentionedRoles.first ~= nil then -- if uses user id and mentions a role
                    role = message.mentionedRoles.first
                elseif message.guild:getRole(argsTable[2]) ~= nil then -- if uses user id and role id
                    role = message.guild:getRole(argsTable[2])
                end
            end
            if member == nil or role == nil then
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
        if not author:hasPermission("manageRoles") then
            local reply = message:reply("nice try retard")
            discordia.Clock():waitFor("",3000)
            message:delete()
            reply:delete()
        else
            local role
            if message.mentionedRoles.first ~= nil then
                role = message.mentionedRoles.first
            elseif message.guild:getRole(args) ~= nil then
                role = message.guild:getRole(args)
            end

            if role == nil then
                message:reply(err)
            else
                local rolename = role.name
                message:addReaction("✨")
                role:delete()
                message:reply({ embed = {description ="<:shSuccess:835619376052174848> deleted **"..rolename.."**", color = discordia.Color.fromHex("#43B581").value}})
            end
        end
    end
end)

client:run('Bot '..botToken)