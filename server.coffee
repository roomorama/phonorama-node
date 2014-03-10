twilio  = require 'twilio'
express = require 'express'
routes  = require './routes'
dotenv = require 'dotenv'
logger = require './lib/access_logger'
dotenv.load()

app = express()
app.use express.urlencoded()
app.use logger

if process.env.NODE_ENV == 'production'
  errorHandler = require('./lib/error_handler')
  app.use errorHandler

app.get '/', (req, res) -> res.send 200

# Secure all post methods wth webhook
app.use twilio.webhook(process.env.TWILIO_AUTH_TOKEN,
                         validate: process.env.NODE_ENV == 'production'
                         host: 'phone.roomorama.io'
                         protocol: 'https')

app.post '/', routes.index
app.post '/menu', routes.menu
app.post '/fallback', routes.fallback
app.post '/booking/pay-by-phone', routes.booking.payByPhone
app.post '/booking/inquiry/:repeat?', routes.booking.inquiry

app.listen(process.env.PORT || 3001)