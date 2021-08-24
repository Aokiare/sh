-- Licensed under the Open Software License version 3.0

return {
    name = 	'ping',
    description = 'ping the bot',
    hidden = false,
    command = function (message)
        local stopwatch = discordia.Stopwatch()
        stopwatch:start()
        local reply = message:reply({
            embed = {
                description = botEmote.."calculating", color = botColor
            }
        })
        stopwatch:stop()
        local pingTime = math.floor(stopwatch:getTime():toMilliseconds())
        stopwatch:reset()
        reply:setEmbed{
            description = botEmote.." "..pingTime.."ms",
            color = botColor
        }
    end
}