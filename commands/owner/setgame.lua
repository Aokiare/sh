return {
    name = "setgame",
    description = "set playing text for the bot",
    hidden = true,
    command = function (message)
        if message.author ~= owner then message:addReaction("🤡") return end
        if args then client:setStatus(args) else client:setStatus() end
    end
}