Log = require 'log'
fs = require 'fs'

log = new Log('info', fs.createWriteStream("./log/activity.log"))

module.exports = log
