roomoramaDb = require './roomorama_db'

exports.inquiryValidForCall = (inquiry_id, callback) ->
  roomoramaDb.Inquiry.find(inquiry_id).success (inquiry) ->
    if inquiry
      valid_for_call = true
      callback(valid_for_call, inquiry)
    else
      callback(false, inquiry)
