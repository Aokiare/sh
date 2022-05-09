-- Licensed under the Open Software License version 3.0

return {
    name = "color",
    description = "return values of a color",
    hidden = false,
    command = function(message) -- this is like the first thing i ever wrote in lua so it is a fucking mess and im terrified of ever touching it, werks on my machine tho
        -- TODO: rewrite the whole thing using the color api. will probably never happen but hey, if im ever bored to death;)
        local author = message.guild:getMember(message.author.id)
        local decimal, hex, r, g, b, rgb
        if not args then --no input after command, default to highest role color
            decimal = author:getColor().value
            hex = discordia.Color(decimal):toHex()
            r, g, b = discordia.Color(decimal):toRGB()
            rgb = r .. ", " .. g .. ", " .. b
        elseif utils.isHex(args) then -- check if input is a hex
            hex = args:upper()
            decimal = discordia.Color.fromHex(hex).value
            r, g, b = discordia.Color(decimal):toRGB()
            rgb = r .. ", " .. g .. ", " .. b
        elseif string.find(args, ",") then -- basic check if input is rgb
            local rgbTable = string.split(args, ",")
            r, g, b = tonumber(string.trim(rgbTable[1])), tonumber(string.trim(rgbTable[2])), tonumber(string.trim(rgbTable[3]))
            if utils.isRGB(r) and utils.isRGB(g) and utils.isRGB(b) then -- validate input
                rgb = r .. ", " .. g .. ", " .. b
                decimal = discordia.Color.fromRGB(r, g, b).value
                hex = discordia.Color(decimal):toHex()
            end
        elseif utils.isDecimal(args) then -- check if input is decimal
            decimal = tonumber(args)
            hex = discordia.Color(decimal):toHex()
            r, g, b = discordia.Color(decimal):toRGB()
            rgb = r .. ", " .. g .. ", " .. b
        elseif message.mentionedUsers.first then --check if mentions someone, get highest role color
            local member = message.guild:getMember(message.mentionedUsers.first.id)
            decimal = member:getColor().value
            hex = discordia.Color(decimal):toHex()
            r, g, b = discordia.Color(decimal):toRGB()
            rgb = r .. ", " .. g .. ", " .. b
        end
        if not hex or not rgb or not decimal then return message:reply(err) end
        local imageColor = hex:sub(2):lower()
        local nameResponse, nameResult = http.request("GET", "https://www.thecolorapi.com/id?hex=" .. hex:sub(2))
        local colorName
        if nameResponse.code ~= 200 then
            colorName = failEmote .. " http request failed with code **" .. nameResponse.code .. "**"
        else
            colorName = json.decode(nameResult).name.value
        end
        message:reply({
            embed = {
                fields = {
                    {
                        name = "Name",
                        value = colorName
                    },
                    {
                        name = "Hex",
                        value = hex,
                        inline = true
                    },
                    {
                        name = "RGB",
                        value = rgb,
                        inline = true
                    },
                    {
                        name = "Decimal",
                        value = decimal,
                        inline = true
                    }
                },
                color = discordia.Color.fromHex(hex).value,
                thumbnail = {
                    url = "https://dummyimage.com/200x200/" .. imageColor .. "/" .. imageColor .. ".png"
                }
            }
        })
    end
}
