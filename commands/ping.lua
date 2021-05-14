return {
	name = 	'ping',
	description = 'ping the bot',
    hidden = false,
	command = function (message)
        message:reply({embed = {description = "<a:rosebox_hearts:842568705015021590> pong", color = 0xa57562}})
    end
}