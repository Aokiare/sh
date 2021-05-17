return {
    name = 	"info",
    description = "info about the bot",
    hidden = false,
    command = function (message)
        local time = os.time() - utils.timeInit
        local hours = string.format("%1.f", math.floor(time/3600));
        local mins = string.format("%1.f", math.floor(time/60 - (hours*60)));
        local secs = string.format("%1.f", math.floor(time - hours*3600 - mins *60));
        local mb = string.format("%2.2f", collectgarbage("count")/1000)
        local uptime = ""
        if hours ~= "0" then
            uptime = uptime .. hours .. " hours "
        end
        if mins ~= "0" then
            uptime = uptime .. mins .. " mins "
        end
        uptime = uptime .. secs .. " secs "
        message:reply({
            embed = {
                author ={
                    name = bot.tag,
                    icon_url = bot:getAvatarURL(1024)
                },
                fields ={
                    {
                        name = "ram usage",
                        value = (mb.."MB"),
                        inline = false
                    },
                    {
                        name = "uptime",
                        value = uptime,
                        inline = false
                    }
                },
                color = 0xa57562 -- hex color code
            }})
    end
}