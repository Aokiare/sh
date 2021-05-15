return {
    name = "say",
    description = "repeat a sentence",
    hidden = true,
    command = function (message)
        if message.author ~= client.owner then message:addReaction("🤡") return end
        local msg = args
        local channel = message.channel
        message:delete()
        channel:send(msg)
    end
}