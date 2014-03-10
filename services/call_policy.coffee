roomoramaDb = require './roomorama_db'

valid_for_call_states = ["cancelled", "guest_to_pay", "host_to_confirm"]

exports.inquiryValidForCall = (inquiry_id, callback) ->
  roomoramaDb.Inquiry.find(inquiry_id).success (inquiry) ->
    if inquiry
      valid_for_call = valid_for_call_states.indexOf(inquiry.state) != -1
      callback(valid_for_call, inquiry)
    else
      callback(false, inquiry)
