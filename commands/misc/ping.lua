return {
    name = 	'ping',
    description = 'ping the bot',
    hidden = false,
    command = function (message)
        local start = os.clock()
        local reply = message:reply({embed = {description = "<a:rosebox_hearts:842568705015021590> pong", color = botColor}})
        local finish = os.clock()
        local time = (finish - start) * 1000
        reply:setEmbed{
            description = [[<a:rosebox_hearts:842568705015021590> pong
<a:time:845998443209031740> ]]..time.."ms",
            color = botColor
        }
    end
}