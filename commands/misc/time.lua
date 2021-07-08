-- Licensed under the Open Software License version 3.0

return {
    name = "time",
    description = "returns time in the right timezone",
    hidden = false,
    command = function (message)
        local author = message.guild:getMember(client.owner.id)
        local time = os.date("%I:%M:%S %p", os.time() + 2 * 60 * 60)
        local date = os.date("%d %B %Y", os.time() + 2 * 60 * 60)
        local dayoftheweek = os.date("%A", os.time() + 2 * 60 * 60)
        message:reply({
            embed = {
                author = {
                    name = author.tag,
                    icon_url = author:getAvatarURL()
                },
                fields = {
                    {
                        name = "Time",
                        value = time
                    },
                    {
                        name = "Date",
                        value = date
                    },
                    {
                        name = "Day",
                        value = dayoftheweek:upper()
                    }
                },
                thumbnail = {
                    url = "https://i.imgur.com/9Tq1txG.png"
                },
                color = botColor;
            }
        })
    end
}