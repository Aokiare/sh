local commands = {}
commands["ping"] = require("./ping")
commands["avatar"] = require("./avatar")
commands["color"] = require("./color")
commands["info"] = require("./info")
commands["time"] = require("./time")
commands["ban"] = require("./admin/ban")
commands["kick"] = require("./admin/kick")
commands["clear"] = require("./admin/clear")
commands["crole"] = require ("./admin/crole")
commands["arole"] = require ("./admin/arole")
commands["drole"] = require ("./admin/drole")
commands["role"] = require ("./role")
commands["user"] = require ("./user")
commands["lain"] = require ("./voice/lain")

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
            color = 0xa57562,
            footer = {text = bot.name.." is owned by "..owner.tag.." • Today at "..os.date("%I:%M %p", os.time())}
        }})
	end
}
return commands