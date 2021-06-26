return {
    name = "shorten",
    description = "shorten a link",
    hidden = false,
    command = function (message)
        if not args then return message:reply(err) end
        local headers = {
            {"Content-Type", "application/x-www-form-urlencoded"},
            {"Accept", "application/json"}
        }
        local data = "shorten="..args
        local res, url = http.request("POST", "https://0x0.st", headers, data)
        if res["code"] == 400 then
            message:reply({ embed = {
                color = 0xEA4445,
                description = "<:shError:835619357249241159> 400 BAD REQUEST"
            }})
        elseif res["code"] == 200 then
            message:addReaction("✨")
            message:reply({
                embed = {
                    description = "<a:rosebox_hearts:842568705015021590> "..url,
                    color = botColor
                }
            })
        else
            message:reply(err)
        end
    end
}