rollbar = require 'rollbar'
config = require './config'
rollbarToken = config.rollbar.post_server_item_access_token
module.exports = rollbar.errorHandler(rollbarToken)