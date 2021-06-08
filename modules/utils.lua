local utils = {}
function utils.getStream(url)
    local child = spawn('youtube-dl', {
        args = {'-g', url},
        stdio = { nil, true, 2 }
    })

    local stream
    for chunk in child.stdout.read do
        local urls = chunk:split('\n')

        for _, yturl in pairs(urls) do
            local mime = parse(yturl, true).query.mime

            if mime and mime:find('audio') == 1 then
                stream = yturl
            end
        end
    end

    return stream
end
function utils.isLink(str)
    return utils.startsWith(str, "http://") or utils.startsWith(str, "https://") or utils.startsWith(str, "www.") or utils.startsWith(str, "youtube.com/watch?v=")
end
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
function utils.tableToString(tbl)
    local result = ""
    for k, v in pairs(tbl) do
        if result == "" then
            result = result..v
        else
            result = result..", "
            result = result..v
        end
    end
    return result..""
end
utils.timeInit = os.time()
_G.err = { embed = {description ="<:shError:835619357249241159> nah something aint right", color = 0xEA4445}}
return utils