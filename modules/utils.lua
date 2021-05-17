local utils = {}
function utils.hasPrefix(string,prefix)
	if string:sub(1,#prefix) == prefix then
		return true
	else
		return false
	end
end
function utils.removeFirstWord(string)
	if string:find("%s") then
	return string:sub(string:find("%s"),#string)
	end
end
function utils.startsWith(str, start)
    return str:sub(1, #start) == start
end
function utils.isNumeric(str)
    return tonumber(str) ~= nil
end
function utils.isHex(str)
    return utils.startsWith(str, "#") and #str == 7
end
function utils.isRGB(str)
    return utils.isNumeric(str) and str <= 255
end
function utils.isDecimal(str)
    return utils.isNumeric(str) and tonumber(str) <= 16777215
end
utils.timeInit = os.time()
_G.err = { embed = {description ="<:shError:835619357249241159> nah something aint right", color = 0xEA4445}}
return utils