---@diagnostic disable: undefined-field
_G.discordia = require("discordia")
_G.client = discordia.Client()
_G.helpers = require("./modules/helpers")
_G.config = require("./modules/config")
_G.voiceAnnouncements = require("./modules/voiceAnnouncements")
_G.commands = require("./commands")
_G.FileReader = require ("fs")
discordia.extensions()

local prefix = ">>"
local botToken = assert(FileReader.readFileSync("./token")) -- token plaintext file

client:on("ready", function()
    client:setStatus("dnd")
    print(os.date("%F %T", os.time()).." | \027[94m[BOT]\027[0m     | "..client.user.username.." is online!")
    _G.bot = client:getUser(client.user.id)
    _G.owner = client:getUser(client.owner.id)
    collectgarbage("collect")
end)

client:on("voiceChannelJoin", function(member, vc)
    announceJoin(member, vc)
end)

client:on("voiceChannelLeave", function(member, vc)
    announceLeave(member, vc)
end)

client:on("voiceUpdate", function(member)
    announceUpdate(member)
end)

client:on("messageCreate", function(message)
    if message.author.bot or message.author == client.user then return end

    if helpers.hasPrefix(message.content,prefix) then
        local command = string.sub(message.content,#prefix+1,message.content:find("%s"))
        command = command:gsub("%s+","")
        _cmd, _G.args = message.content:match("^(%S+)%s+(.+)$")

        -- Run a command if it exists
        if commands[command] ~= nil then
            commands[command].command(message)
        end
    end
    collectgarbage("collect")
end)

client:run("Bot "..botToken)