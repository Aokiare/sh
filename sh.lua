-- Licensed under the Open Software License version 3.0

_G.discordia = require("discordia")
_G.client = discordia.Client()
_G.FileReader = require("fs")
_G.http = require("coro-http")
_G.json = require("json")
_G.pp = require("pretty-print")
_G.utils = require("./modules/utils")
_G.config = require("./modules/config")
_G.alias = require("./modules/aliases")
_G.voiceAnnouncements = require("./modules/voiceAnnouncements")
_G.commands = require("./commands")
_G.spawn = require("coro-spawn")
_G.parse = require("url").parse
_G.keepAlive = require("./modules/keepAlive") -- only needed for repl.it
discordia.extensions()

client:on("ready", function()
    client:setStatus("dnd")
    print(os.date("%F %T", os.time() + 2 * 60 * 60).." | \027[94m[BOT]\027[0m     | "..client.user.username.." is online!")
    _G.bot = client:getUser(client.user.id)
    _G.owner = client:getUser(client.owner.id)
    collectgarbage("collect")
end)

client:on("messageCreate", function(message)
    if message.author.bot or message.author == client.user then return end

    if utils.hasPrefix(message.content,prefix) then
        local command = string.sub(message.content,#prefix+1,message.content:find("%s")):lower()
        command = command:gsub("%s+","")
        _, _G.args = message.content:match("^(%S+)%s+(.+)$")

        for key, value in pairs(aliases) do
            if command == key then
                command = value
                break
            end
        end

        -- Run a command if it exists
        if commands[command] then
            commands[command].command(message)
        end
    end
    collectgarbage("collect")
end)

client:run("Bot "..botToken)