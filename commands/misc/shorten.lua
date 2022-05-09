-- Licensed under the Open Software License version 3.0

return {
    name = "shorten",
    description = "shorten a link",
    hidden = false,
    command = function(message)
        if not args then return message:reply(err) end
        local headers = {
            { "Content-Type", "application/x-www-form-urlencoded" },
            { "Accept", "application/json" }
        }
        local data = "shorten=" .. args
        local response, result = http.request("POST", "https://envs.sh", headers, data)
        if response.code ~= 200 then
            message:reply({ embed = {
                color = failColor,
                description = failEmote .. " http request failed with code **" .. response.code .. "**"
            } })
        else
            message:reply({
                embed = {
                    description = botEmote .. " " .. result,
                    color = botColor
                }
            })
        end
    end
}
