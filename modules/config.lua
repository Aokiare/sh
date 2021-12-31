-- Licensed under the Open Software License version 3.0

local cfg = json.decode(fs.readFileSync("./config.json"))

_G.prefix = cfg.prefix
_G.botToken = cfg.botToken
_G.njallaToken = cfg.njallaToken
_G.botEmote = cfg.botEmote
_G.successEmote = cfg.successEmote
_G.failEmote = cfg.failEmote
_G.botColor = discordia.Color.fromHex(cfg.botColor).value
_G.successColor = discordia.Color.fromHex(cfg.successColor).value
_G.failColor = discordia.Color.fromHex(cfg.failColor).value