return {
    name = "setstatus",
    description = "set the status of the bot",
    hidden = true,
    command = function (message)
        if message.author ~= client.owner then message:addReaction("🤡") return end
        if args == "dnd" or args == "idle" or args == "online" or args == "invisible" then client:setStatus(args) return else message:reply(err) return end
    end
}