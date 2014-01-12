twilio = require 'twilio'
express = require 'express'
rest = require 'restler'
twilioMiddleware = twilio.webhook(validate: false)

app = express()
app.use express.urlencoded()
app.use express.logger('dev')
app.use twilioMiddleware

app.post '/', (req, res) ->
  resp = new twilio.TwimlResponse()
  resp.say {voice:'alice'}, "Welcome to Room'orama"
  res.send resp

app.post '/paybyphone', (req, res) ->
  inquiryId = req.param('inquiry_id')
  resp = new twilio.TwimlResponse()
  resp.say {voice:'alice'}, 'Welcome to Roomorama'
  res.send resp
    
app.post '/fallback', twilio.webhook(validate: false), (req, res) ->
  resp = new twilio.TwimlResponse()
  resp.say {voice: 'alice'}, 'Sorry, there was an error processing your call'

app.listen(process.env.PORT || 3000)