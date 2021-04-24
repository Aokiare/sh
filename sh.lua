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
	local cmd, args = message.content:match("^(%S+)%s+(.+)$")
	cmd = cmd or message.content
    if message.author.bot or message.author == client.user then return end

    if cmd == prefix.."ping" then
        message:reply({embed = {title = "pong", color = discordia.Color.fromHex("#a57562").value;}})
    end

    if cmd == prefix.."avatar" then
        local author = message.author
        local member = message.mentionedUsers.first
        if args == nil then
            local authorId = message.guild:getMember(message.author.id)
            local avatar = author:getAvatarURL(1024)
            message:reply({embed = {author = {name = author.tag, icon_url = avatar}, image = {url = avatar}, color = authorId:getColor().value;}})
            -- message:reply({embed = {author = {name = author.tag, icon_url = avatar}, image = {url = avatar}, color = discordia.Color.fromHex("#a57562").value;}})
        elseif member then
            local memberId = message.guild:getMember(member.id)
            local avatar = member:getAvatarURL(1024)
            -- message:reply("**"..member.tag.."**'s avatar\n"..avatar)
            message:reply({embed = {author = {name = member.tag, icon_url = avatar}, image = {url = avatar}, color = memberId:getColor().value;}})
        else
            message:reply("?")
        end
    end

    if cmd == prefix.."color" then
        if args == nil then --no input after command, default to highest role color
            local author = message.guild:getMember(message.author.id)
            local decimal = author:getColor().value
            local hex = discordia.Color(decimal):toHex()
            local r,g,b = discordia.Color(decimal):toRGB()
            local rgb = r..", "..g..", "..b
            message:reply({embed = {fields = { {name = "Hex", value = hex}, {name = "RGB", value = rgb}, {name = "Decimal", value = decimal}},color = discordia.Color.fromHex(hex).value;}})
        else
            if startsWith(args, "#") then --basic check if input is a hex
                if #args == 7 then --validate it is a hex
                    local hex = args:upper()
                    local decimal = discordia.Color.fromHex(hex).value
                    local r,g,b = discordia.Color(decimal):toRGB()
                    local rgb = r..", "..g..", "..b
                    message:reply({embed = {fields = { {name = "Hex", value = hex}, {name = "RGB", value = rgb}, {name = "Decimal", value = decimal}},color = discordia.Color.fromHex(hex).value;}})
                else --input is not a hex
                    message:reply("that is not a valid color")
                end
            elseif message.mentionedUsers ~= nil then --check if mentions someone, get highest role color
                local member = message.mentionedUsers.first
                local memberId = message.guild:getMember(member.id)
                local decimal = memberId:getColor().value
                local hex = discordia.Color(decimal):toHex()
                local r,g,b = discordia.Color(decimal):toRGB()
                local rgb = r..", "..g..", "..b
                message:reply({embed = {fields = { {name = "Hex", value = hex}, {name = "RGB", value = rgb}, {name = "Decimal", value = decimal}},color = discordia.Color.fromHex(hex).value;}})
            elseif string.find(args, ",") ~= nil then --basic check if input is rgb
                local rgbTable = string.split(args, ",")
                local r,g,b = tonumber(string.trim(rgbTable[1])),tonumber(string.trim(rgbTable[2])),tonumber(string.trim(rgbTable[3]))
                if isRGB(r) and isRGB(g) and isRGB(b) then --validate input
                    local rgb = r..", "..g..", "..b
                    local decimal = discordia.Color.fromRGB(r,g,b).value
                    local hex = discordia.Color(decimal):toHex()
                    message:reply({embed = {fields = { {name = "Hex", value = hex}, {name = "RGB", value = rgb}, {name = "Decimal", value = decimal}},color = discordia.Color.fromHex(hex).value;}})
                else
                    message:reply("that is not a valid color")
                end
            elseif isDecimal(args) then --check if input is decimal
                local decimal = tonumber(args)
                local hex = discordia.Color(decimal):toHex()
                local r,g,b = discordia.Color(decimal):toRGB()
                local rgb = r..", "..g..", "..b
                message:reply({embed = {fields = { {name = "Hex", value = hex}, {name = "RGB", value = rgb}, {name = "Decimal", value = decimal}},color = discordia.Color.fromHex(hex).value;}})
            else
                message:reply("that is not a valid color retard")
            end
        end
    end

    if cmd == prefix.."ban" then
        local author = message.guild:getMember(message.author.id)

        if startsWith(args, "<@!") then --if mentioned
            local member = message.mentionedUsers.first
            if not author:hasPermission("banMembers") then
                message:reply("nice try retard")
            else
                if not member then
                    message:reply("mention a retard to kick")
                else
                    message:addReaction("✨")
                    for user in message.mentionedUsers:iter() do
                        member = message.guild:getMember(user.id)
                        if author.highestRole.position > member.highestRole.position then
                            member:ban()
                        end
                    end
                    message:reply("fuck outta here")
                end
            end
        elseif message.guild:getMember(args) ~= nil then
            if not author:hasPermission("banMembers") then
                message:reply("nice try retard")
            else
                message:addReaction("✨")
                message.guild:banUser(args)
                message:reply("fuck outta here")
            end
        end
    end

    if cmd == prefix.."kick" then
        local author = message.guild:getMember(message.author.id)

        if startsWith(args, "<@!") then --if mentioned
            local member = message.mentionedUsers.first
            if not author:hasPermission("kickMembers") then
                message:reply("nice try retard")
            else
                if not member then
                    message:reply("mention a retard to kick")
                else
                    message:addReaction("✨")
                    for user in message.mentionedUsers:iter() do
                        member = message.guild:getMember(user.id)
                        if author.highestRole.position > member.highestRole.position then
                            member:kick()
                        end
                    end
                    message:reply("outta here")
                end
            end
        elseif message.guild:getMember(args) ~= nil then --if ids
            if not author:hasPermission("kickMembers") then
                message:reply("nice try retard")
            else
                message:addReaction("✨")
                message.guild:kickUser(args)
                message:reply("outta here")
            end
        end
    end

    if cmd == prefix.."time" then --command to display my own time in my own timezone
        local author = message.guild:getMember(client.owner.id)
        local time = os.date("!%I:%M:%S %p", os.time() + 2 * 60 * 60)
        local date = os.date("!%d %B, %Y", os.time() + 2 * 60 * 60)
        local dayoftheweek = os.date("!%A", os.time() + 2 * 60 * 60)
        message:reply({embed = {author = {name = author.tag, icon_url = author:getAvatarURL()}, fields = {{name = "Time", value = time}, {name = "Date", value = date}, {name = "Day", value = dayoftheweek:upper()}}, thumbnail = {url = "https://i.imgur.com/9Tq1txG.png"},color = discordia.Color.fromHex("#a57562").value;}})
    end

    if cmd == prefix.."clear" then
        local author = message.guild:getMember(message.author.id)
        local channel = message.guild:getChannel(message.channel.id)
        if author:hasPermission("manageMessages") and isNumeric(args) then
            message:addReaction("✨")
            channel:bulkDelete(message.channel:getMessagesBefore(message.id, args))
            if args == "1" then
                local reply = message:reply({ embed = {description =args.." message was deleted by "..author.tag, color = discordia.Color.fromHex("#a57562").value}})
                discordia.Clock():waitFor("",5000)
                reply:delete()
                message:delete()
            else
                local reply = message:reply({ embed = {description =args.." messages were deleted by "..author.tag, color = discordia.Color.fromHex("#a57562").value}})
                discordia.Clock():waitFor("",5000)
                reply:delete()
                message:delete()
            end
        else
            message:reply("?")
        end
    end

    if cmd == prefix.."crole" then
        local author = message.guild:getMember(message.author.id)
        local server = message.guild
        if string.find(args, ",") then
            local argsTable = string.split(args,",") -- name, hex color, hoisted, mentioned
            if author:hasPermission("manageRoles") and string.trim(argsTable[1]) then
                message:addReaction("✨")
                local role = server:createRole(string.trim(argsTable[1]))
                if string.trim(argsTable[2]) and isHex(string.trim(argsTable[2])) then
                    role:setColor(discordia.Color.fromHex(string.trim(argsTable[2])))
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
                end
                local reply = message:reply({ embed = {description ="<:shSuccess:835619376052174848> created role "..role.name, color = discordia.Color.fromHex("#43B581").value}})
            end
        else
            if author:hasPermission("manageRoles") then
                message:addReaction("✨")
                local role = server:createRole(args)
                local reply = message:reply({ embed = {description ="<:shSuccess:835619376052174848> created role "..role.name, color = discordia.Color.fromHex("#43B581").value}})
            end
        end
    end

end)

client:run('Bot '..botToken)