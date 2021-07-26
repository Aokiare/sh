-- Licensed under the Open Software License version 3.0

return {
    name = "webm",
    description = "get a random webm from a /wsg/",
    hidden = false,
    command = function (message)
        math.randomseed(os.time())

        local targetBoard = "wsg"

        local function getThread()
            local _, data = http.request("GET", "https://a.4cdn.org/"..targetBoard.."/catalog.json")
            local parsedData = json.decode(data)
            return tonumber(parsedData[math.random(1, 10)]["threads"][math.random(1, 15)]["no"])
        end

        local function getReplyWebm(threadNumber)
            local _, data = http.request("GET", "https://a.4cdn.org/"..targetBoard.."/thread/"..threadNumber..".json")
            local parsedData = json.decode(data)
            local postNumber = math.random(1, #parsedData["posts"])
            return {
            tonumber(parsedData["posts"][postNumber]["tim"]), -- webm name
            parsedData["posts"][postNumber]["ext"], -- extension
            parsedData["posts"][postNumber]["no"], -- post number
            parsedData["posts"][postNumber]["time"], -- post time
            parsedData["posts"][postNumber]["filename"] -- webm filename
            }
        end

        local threadNumber = getThread()
        local webmData = getReplyWebm(threadNumber)

        while not webmData[1] or webmData[2] ~= ".webm" do
            threadNumber = getThread()
            webmData = getReplyWebm(threadNumber)
        end

        message:reply("https://i.4cdn.org/"..targetBoard.."/"..webmData[1]..webmData[2])
        message:reply({
            embed = {
                color = botColor,
                title = "No."..webmData[3],
                description = webmData[5]..webmData[2],
                author = {
                    name = "/"..targetBoard.."/",
                    icon_url = "https://i.imgur.com/XcCKhYj.png",
                    url = "https://boards.4channel.org/"..targetBoard.."/thread/"..threadNumber.."#p"..webmData[3]
                },
                footer = {
                    text = webmData[1].." • "..os.date("%d %b %Y %I:%M:%S %p" ,webmData[4])
                }
            }
        })
    end
}