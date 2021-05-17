return {
    name = "color",
    description = "return values of a color",
    hidden = false,
    command = function (message)
        local author = message.guild:getMember(message.author.id)
        local decimal, hex, r, g, b, rgb
        if not args then --no input after command, default to highest role color
            decimal = author:getColor().value
            hex = discordia.Color(decimal):toHex()
            r,g,b = discordia.Color(decimal):toRGB()
            rgb = r..", "..g..", "..b
        elseif utils.isHex(args) then -- check if input is a hex
            hex = args:upper()
            decimal = discordia.Color.fromHex(hex).value
            r,g,b = discordia.Color(decimal):toRGB()
            rgb = r..", "..g..", "..b
        elseif string.find(args, ",") then -- basic check if input is rgb
            local rgbTable = string.split(args, ",")
            r,g,b = tonumber(string.trim(rgbTable[1])),tonumber(string.trim(rgbTable[2])),tonumber(string.trim(rgbTable[3]))
            if utils.isRGB(r) and utils.isRGB(g) and utils.isRGB(b) then -- validate input
                rgb = r..", "..g..", "..b
                decimal = discordia.Color.fromRGB(r,g,b).value
                hex = discordia.Color(decimal):toHex()
            end
        elseif utils.isDecimal(args) then -- check if input is decimal
            decimal = tonumber(args)
            hex = discordia.Color(decimal):toHex()
            r,g,b = discordia.Color(decimal):toRGB()
            rgb = r..", "..g..", "..b
        elseif message.mentionedUsers.first then --check if mentions someone, get highest role color
            local member = message.guild:getMember(message.mentionedUsers.first.id)
            decimal = member:getColor().value
            hex = discordia.Color(decimal):toHex()
            r,g,b = discordia.Color(decimal):toRGB()
            rgb = r..", "..g..", "..b
        end
        if not hex or not rgb or not decimal then
            message:reply(err)
        else
            message:reply({embed = {fields = { {name = "Hex", value = hex}, {name = "RGB", value = rgb}, {name = "Decimal", value = decimal}},color = discordia.Color.fromHex(hex).value;}})
        end
    end
}