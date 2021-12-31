-- Licensed under the Open Software License version 3.0

return {
    name = "domain",
    description = "query njal.la for domain status",
    hidden = false,
    command = function (message)
        local token = "Njalla "..njallaToken
        if not token then return message:reply({embed {description = failEmote.." no njalla token provided in config", color = failColor}}) end
        local domainQuery = string.trim(args)

        local headers = {
            {"Content-Type", "application/json"},
            {"Authorization", token}
        }

        local data = {
            method = "find-domains",
            params = {query = domainQuery}
        }

        local response, result = http.request("POST", "https://njal.la/api/1/", headers, json.encode(data))

        if response.code ~= 200 then
            return message:reply({
                embed = {
                    color = failColor,
                    description = failEmote.." http request failed with code **"..response.code.."**"
                }
            })
        end

        local decodedResult = json.decode(result)

        if not decodedResult.result.domains[1] then
            return message:reply({
                embed = {
                    color = failColor,
                    description = failEmote.." that is not a domain"
                }
            })
        end

        local domainName = decodedResult.result.domains[1]["name"]
        local domainStatus = decodedResult.result.domains[1]["status"]
        local domainPrice = decodedResult.result.domains[1]["price"]

        if domainStatus == "taken" then
            message:reply({
                embed = {
                    color = failColor,
                    description = failEmote.." domain **"..domainName.."** is already taken"
                }
            })
        elseif domainStatus == "available" then
            message:reply({
                embed = {
                    color = successColor,
                    description = successEmote.." domain **"..domainName.."** is available for **$"..domainPrice.."**!"
                }
            })
        end
    end
}