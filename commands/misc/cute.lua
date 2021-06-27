return {
    name = "cute",
    description = "get an image from a cute board",
    hidden = false,
    command = function (message)
        math.randomseed(os.time())

        local function getBoard()
            local boards = {"c", "cm"}
            return boards[math.random(1,2)]
        end

        local targetBoard = getBoard()

        local function getThread()
            local _res, data = http.request("GET", "https://a.4cdn.org/"..targetBoard.."/catalog.json")
            local parsedData = json.decode(data)
            return tonumber(parsedData[math.random(1, 10)]["threads"][math.random(1, 15)]["no"])
        end

        local function getReplyImage(threadNumber)
            local _res, data = http.request("GET", "https://a.4cdn.org/"..targetBoard.."/thread/"..threadNumber..".json")
            local parsedData = json.decode(data)
            local postNumber = math.random(1, #parsedData["posts"])
            return {
            tonumber(parsedData["posts"][postNumber]["tim"]), -- image name
            parsedData["posts"][postNumber]["ext"], -- image extension
            parsedData["posts"][postNumber]["no"], -- post number
            parsedData["posts"][postNumber]["time"], -- post time
            parsedData["posts"][postNumber]["filename"] -- image filename
            }
        end

        local wallpaperData = getReplyImage(getThread())

        while not wallpaperData[1] do
            wallpaperData = getReplyImage(getThread())
        end

        local imageUrl = "https://i.4cdn.org/"..targetBoard.."/"..wallpaperData[1]..wallpaperData[2]
        message:reply({
            embed = {
                color = botColor,
                image = {
                    url = imageUrl
                },
                title = "No."..wallpaperData[3],
                description = wallpaperData[5]..wallpaperData[2],
                author = {
                    name = "/"..targetBoard.."/",
                    icon_url = "https://i.imgur.com/XcCKhYj.png"
                },
                footer = {
                    text = wallpaperData[1].." • "..os.date("%d %b %Y %I:%M:%S %p" ,wallpaperData[4])
                }
            }
        })
    end
}