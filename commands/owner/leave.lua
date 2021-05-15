return {
    name = "leave",
    description = "leaves the guild",
    hidden = true,
    command = function (message)
        if message.author ~= client.owner then message:addReaction("🤡") return end
        message:addReaction("✨")
        message:reply("aight im headin out")
        message.guild:leave()
    end
}