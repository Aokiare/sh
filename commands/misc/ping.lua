return {
    name = 	'ping',
    description = 'ping the bot',
    hidden = false,
    command = function (message)
        local stopwatch = discordia.Stopwatch()
        stopwatch:start()
        local reply = message:reply({embed = {description = "<a:rosebox_hearts:842568705015021590> pong", color = botColor}})
        stopwatch:stop()
        local pingTime = math.floor(stopwatch:getTime():toMilliseconds())
        stopwatch:reset()
        reply:setEmbed{
            description = [[<a:rosebox_hearts:842568705015021590> pong
<a:time:845998443209031740> ]]..pingTime.."ms",
            color = botColor
        }
    end
}