twilio = require 'twilio'
inquiryValidator = require '../services/inquiry_validator'

# Check if the booking entered is a valid inquiry, if so, redirect to booking/inquiry_id.
# Otherwise, state the error, and gather back to this URL, incrementing the repeat
exports.enterBooking = (req, res) ->
  numberEntered = req.body.Digits
  inquiryValidator.valid_for_call numberEntered, (valid, inquiry) ->
    if valid
      resp = new twilio.TwimlResponse()
    else



# Perform redirecting actions for a valid inquiry id. Redirect the current call to the Zendesk phone number,
# Then update the created ticket data.
exports.redirect = (req, res) ->
