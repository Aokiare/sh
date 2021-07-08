-- Licensed under the Open Software License version 3.0

local commands = {}
commands["ban"] = require("./admin/ban")
commands["unban"] = require("./admin/unban")
commands["kick"] = require("./admin/kick")
commands["clear"] = require("./admin/clear")
commands["nickname"] = require("./admin/nickname")
commands["crole"] = require ("./admin/crole")
commands["drole"] = require ("./admin/drole")
commands["arole"] = require ("./admin/arole")
commands["rrole"] = require ("./admin/rrole")
commands["move"] = require ("./admin/move")
commands["mute"] = require ("./admin/mute")
commands["unmute"] = require ("./admin/unmute")
commands["deafen"] = require ("./admin/deafen")
commands["undeafen"] = require ("./admin/undeafen")
commands["vckick"] = require ("./admin/vckick")
commands["ping"] = require("./misc/ping")
commands["avatar"] = require("./misc/avatar")
commands["color"] = require("./misc/color")
commands["info"] = require("./misc/info")
commands["time"] = require("./misc/time")
commands["role"] = require ("./misc/role")
commands["user"] = require ("./misc/user")
commands["quote"] = require ("./misc/quote")
commands["shorten"] = require ("./misc/shorten")
commands["cute"] = require ("./misc/cute")
commands["webm"] = require ("./misc/webm")
commands["play"] = require ("./voice/play")
commands["lain"] = require ("./voice/lain")
commands["disconnect"] = require ("./voice/disconnect")
commands["pause"] = require ("./voice/pause")
commands["resume"] = require ("./voice/resume")
commands["leave"] = require ("./owner/leave")
commands["say"] = require ("./owner/say")
commands["setstatus"] = require ("./owner/setstatus")
commands["setgame"] = require ("./owner/setgame")
commands["eval"] = require ("./owner/eval")

commands["help"] =
{
	name = "help",
	description = "print this message",
    hidden = false,
	command = function(message)
    local mess = ""
    for  k,v in pairs(commands) do
        if commands[k].hidden == false then
            mess = mess .. "`" .. commands[k].name .. "` - " .. commands[k].description .. "\n"
        end
    end
    message:reply({
        embed = {
            author = {
                name = bot.name.."'s help page",
                icon_url = bot:getAvatarURL(1024)
            },
            description = mess,
            color = botColor,
            footer = {text = bot.name.." is owned by "..owner.tag.." • Today at "..os.date("%I:%M %p", os.time())}
        }})
	end
}
return commands