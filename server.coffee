twilio  = require 'twilio'
express = require 'express'
rest    = require 'restler'
routes  = require './routes'

twilioMiddleware = twilio.webhook(validate: process.env.NODE_ENV == 'production')

app = express()
app.use express.urlencoded()
app.use express.logger('dev')
app.use twilioMiddleware

app.post '/', routes.index
app.post '/menu', routes.menu
app.post '/pay-by-phone', routes.payByPhone
app.post '/fallback', routes.fallback
app.post '/booking/inquiry/:repeat?', routes.booking.inquiry

app.listen(process.env.PORT || 3000)