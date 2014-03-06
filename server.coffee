twilio  = require 'twilio'
express = require 'express'
routes  = require './routes'
env = require('./opsworks').customEnvironment

twilioMiddleware = twilio.webhook(validate: process.env.NODE_ENV == 'production')

app = express()
app.use express.urlencoded()
app.use express.logger('dev')
app.use twilioMiddleware

if process.env == 'production'
  rollbar = require 'rollbar'
  config = require './config'
  app.use config.rollbar.post_server_item_access_token

app.post '/', routes.index
app.post '/menu', routes.menu
app.post '/fallback', routes.fallback
app.post '/booking/pay-by-phone', routes.booking.payByPhone
app.post '/booking/inquiry/:repeat?', routes.booking.inquiry

app.listen(env.PORT || 3000)