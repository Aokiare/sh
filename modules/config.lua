local FileReader = require ('fs')


_G.prefix = ">>"
_G.botToken = assert(FileReader.readFileSync("./token"))