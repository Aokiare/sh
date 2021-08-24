-- Licensed under the Open Software License version 3.0

return {
    name = "eval",
    description = "execute lua code",
    hidden = true,
    command = function (message)
        local sandbox = setmetatable({ }, { __index = _G })

        if message.author ~= owner then return end
        local _, evalCommand = message.content:match("^(%S+)%s+(.+)$")
        if not evalCommand then return message:reply(err) end

        evalCommand = evalCommand:gsub('```lua\n?', ''):gsub('```\n?', '')

        local lines = {}

        sandbox.message = message
        sandbox.print = function(...)
            table.insert(lines, utils.printLine(...))
        end
        sandbox.p = function(...)
            table.insert(lines, utils.prettyLine(...))
        end

        local fn, synErr = load(evalCommand, "cutebot", "t", sandbox)
        if not fn then return message:reply({
            embed = {
                fields = {
                    {
                        name = "input",
                        value = utils.luaCode(evalCommand)
                    },
                    {
                        name = "output",
                        value = utils.code(synErr)
                    }
                },
                color = botColor
            }
        })
        end

        local success, runErr = pcall(fn)
        if not success then return message:reply({
            embed = {
                fields = {
                    {
                        name = "input",
                        value = utils.luaCode(evalCommand)
                    },
                    {
                        name = "output",
                        value = utils.code(runErr)
                    }
                },
                color = botColor
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
                        value = utils.luaCode(evalCommand)
                    },
                    {
                        name = "output",
                        value = utils.shellCode(lines)
                    }
                },
                color = botColor
            }
        })
        end
    end
}