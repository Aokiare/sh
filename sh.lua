-- Licensed under the Open Software License version 3.0

_G.discordia = require("discordia")
_G.client = discordia.Client {
    dateTime = '%d %b %Y • %I:%M:%S %p',
}
_G.fs= require("fs")
_G.http = require("coro-http")
_G.json = require("json")
_G.pp = require("pretty-print")
_G.alias = require("./modules/aliases")
_G.config = require("./modules/config")
_G.forwardMessages = require("./modules/forwardMessages")
-- _G.keepAlive = require("./modules/keepAlive") -- only needed for repl.it
_G.utils = require("./modules/utils")
_G.voiceAnnouncements = require("./modules/voiceAnnouncements")
_G.commands = require("./commands")
_G.spawn = require("coro-spawn")
_G.parse = require("url").parse
discordia.extensions()

client:on("ready", function()
    client:setStatus("dnd")
    print(os.date("%d %b %Y • %I:%M:%S %p", os.time()).." | \027[94m[BOT]\027[0m     | "..client.user.username.." is online!")
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
            local currentTime = os.time()
            local location
            if message.guild then location= "#"..message.channel.name..", "..message.guild.name.." ("..message.guild.id..")" else location = message.author.name.."'s dms" end
            print(os.date("%d %b %Y • %I:%M:%S %p" ,currentTime).." | \27[33m[CMD]\27[0m     | "..command:upper().." <- "..message.author.tag.." ("..message.author.id..") "..location)
        end
    end
    collectgarbage("collect")
end)

client:run("Bot "..botToken)