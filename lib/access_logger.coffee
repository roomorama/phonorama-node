express = require 'express'
fs = require 'fs'

express.logger.token 'params', (req, res) ->
  JSON.stringify req.body

express.logger.format 'defaultWithParams',
                      ':remote-addr - - [:date] ":method :url HTTP/:http-version" :params :status :res[content-length] ":referrer" ":user-agent"'

logFile = fs.createWriteStream("./log/#{process.env.NODE_ENV}.log", flags: 'a')

module.exports = express.logger(stream: logFile, format: 'defaultWithParams')