twilio  = require 'twilio'
express = require 'express'
routes  = require './routes'
dotenv = require 'dotenv'
logger = require './lib/access_logger'
dotenv.load()

twilioMiddleware = twilio.webhook(validate: process.env.NODE_ENV == 'production')

app = express()
app.use express.urlencoded()
app.use logger
app.use twilioMiddleware

if process.env.NODE_ENV == 'production'
  rollbar = require 'rollbar'
  config = require './config'
  app.use config.rollbar.post_server_item_access_token

app.get '/', (req, res) -> res.send 200
app.post '/', routes.index
app.post '/menu', routes.menu
app.post '/fallback', routes.fallback
app.post '/booking/pay-by-phone', routes.booking.payByPhone
app.post '/booking/inquiry/:repeat?', routes.booking.inquiry

app.listen(process.env.PORT || 3001)