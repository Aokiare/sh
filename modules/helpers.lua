local helpers = {}
function helpers.hasPrefix(string,prefix)
	if string:sub(1,#prefix) == prefix then
		return true
	else
		return false
	end
end
function helpers.removeFirstWord(string)
	if string:find("%s") then
	return string:sub(string:find("%s"),#string)
	end
end
function helpers.startsWith(str, start)
    return str:sub(1, #start) == start
end
function helpers.isNumeric(str)
    return tonumber(str) ~= nil
end
function helpers.isHex(str)
    return helpers.startsWith(str, "#") and #str == 7
end
function helpers.isRGB(str)
    return helpers.isNumeric(str) and str <= 255
end
function helpers.isDecimal(str)
    return helpers.isNumeric(str) and tonumber(str) <= 16777215
end
helpers.timeInit = os.time()
_G.err = { embed = {description ="<:shError:835619357249241159> nah something aint right", color = 0xEA4445}}
return helpers