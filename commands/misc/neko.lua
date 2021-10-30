-- Licensed under the Open Software License version 3.0

return {
    name = "neko",
    description = "nekos.life command",
    hidden = false,
    command = function (message)
        local _, imageData = http.request("GET", "https://nekos.life/api/v2/img/neko")
        local image = json.decode(imageData)["url"]
        local _, catmojiData = http.request("GET", "https://nekos.life/api/v2/cat")
        local catmoji = json.decode(catmojiData)["cat"]
        message:reply({
            embed = {
                color = botColor,
                author = {
                    name = "neko",
                    icon_url = "https://i.imgur.com/OZbLAD7.png",
                },
                description = catmoji,
                image = {
                    url = image
                }
            }
        })
    end
}