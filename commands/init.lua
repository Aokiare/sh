-- Licensed under the Open Software License version 3.0

local commands = {}

local path = "./commands"
local dirs = fs.readdirSync(path)
dirs = utils.removeExtension(dirs, "lua")

for dir = 1, #dirs do
    local category = dirs[dir]
    local files = fs.readdirSync(path .. "/" .. category)
    for file = 1, #files do
        local cmd = files[file]:gsub(".lua", "")
        commands[cmd] = require("./" .. category .. "/" .. cmd)
    end
    print(os.date("%d %b %Y • %I:%M:%S %p", os.time()) .. " | \27[1;36m[INIT]\27[0m    | Successfully loaded all " .. category:upper() .. " commands")
end

commands["help"] = {
    name = "help",
    description = "print this message",
    hidden = false,
    command = function(message)
        local mess = ""
        for k, v in pairs(commands) do
            if commands[k].hidden == false or message.author == owner then
                mess = mess .. "`" .. commands[k].name .. "` - " .. commands[k].description .. "\n"
            end
        end
        message:reply({
            embed = {
                author = {
                    name = bot.name .. "'s help",
                    icon_url = bot:getAvatarURL(1024)
                },
                description = mess,
                color = botColor,
                footer = { text = bot.name .. " is owned by " .. owner.tag .. " • Today at " .. os.date("%I:%M %p", os.time()) }
            } })
    end
}
return commands
