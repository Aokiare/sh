-- Licensed under the Open Software License version 3.0

return {
    name = "eval",
    description = "execute lua code",
    hidden = true,
    command = function (message)
        local sandbox = setmetatable({ }, { __index = _G })

        if message.author ~= owner then return end
        if not args then return message:reply(err) end

        args = args:gsub('```lua\n?', ''):gsub('```\n?', '')

        local lines = {}

        sandbox.message = message
        sandbox.print = function(...)
            table.insert(lines, utils.printLine(...))
        end
        sandbox.p = function(...)
            table.insert(lines, utils.prettyLine(...))
        end

        local fn, synErr = load(args, "DiscordBot", "t", sandbox)
        if not fn then return message:reply({
            embed = {
                fields = {
                    {
                        name = "input",
                        value = utils.luaCode(args)
                    },
                    {
                        name = "output",
                        value = utils.code(synErr)
                    }
                },
                color = 0xa57562
            }
        })
        end

        local success, runErr = pcall(fn)
        if not success then return message:reply({
            embed = {
                fields = {
                    {
                        name = "input",
                        value = utils.luaCode(args)
                    },
                    {
                        name = "output",
                        value = utils.code(runErr)
                    }
                },
                color = 0xa57562
            }
        })
        end

        lines = table.concat(lines, '\n')

        if #lines > 1990 then
            lines = lines:sub(1, 1990)
        end

        if #lines > 0 then return message:reply({
            embed = {
                fields = {
                    {
                        name = "input",
                        value = utils.luaCode(args)
                    },
                    {
                        name = "output",
                        value = utils.code(lines)
                    }
                },
                color = 0xa57562
            }
        })
        end
    end
}