require './lib/utility'
require('dotenv').load()

twilio = require 'twilio'
express = require 'express'
rest = require 'restler'
routes = require('./routes')

twilioMiddleware = twilio.webhook(validate: false)

app = express()
app.use express.urlencoded()
app.use express.logger('dev')
app.use twilioMiddleware

app.param "inquiry", (req, res, next, id) ->
  Inquiry.find id, (err, user) ->
    if err
      next err
    else if inquiry
      req.inquiry = inquiry
      next()
    else
      next new Error("failed to load inquiry")

app.post '/', routes.index
app.post '/menu', routes.menu

app.post '/booking/enter(/:repeat)', routes.booking.enterBooking

# Perform redirecting actions for a valid inquiry id. Redirect the current call to the Zendesk phone number,
# Then update the created ticket data.
app.post '/booking/:inquiry', routes.booking.redirect

app.post '/pay-by-phone', (req, res) ->
  inquiryId = req.param('inquiry_id')
  resp = new twilio.TwimlResponse()
  resp.dial {method: 'POST', record: false}, ->
    @.number '+18627666553'
  res.send resp

app.post '/fallback', twilio.webhook(validate: false), (req, res) ->
  resp = new twilio.TwimlResponse()
  resp.say {voice: 'alice'}, 'Sorry, there was an error processing your call'

app.listen(process.env.PORT || 3000)

module.exports = app