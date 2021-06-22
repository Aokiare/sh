return {
    name = "shorten",
    description = "shorten a link",
    hidden = false,
    command = function (message)
        local headers = {
            {"Content-Type", "application/x-www-form-urlencoded"},
            {"Accept", "application/json"}
        }
        local data = "shorten="..args
        local _res, url = http.request("POST", "https://0x0.st", headers, data)
        message:reply({embed = {description = "<a:rosebox_hearts:842568705015021590> "..url, color = botColor}})
    end
}