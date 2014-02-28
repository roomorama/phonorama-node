roomoramaDb = require './roomorama_db'
roomoramaDb.connect();

valid_for_call_states = ["cancelled", "guest_to_pay", "host_to_confirm"]

exports.inquiryValidForCall = (inquiry_id, callback) ->
  roomoramaDb.Inquiry.get inquiry_id, (err, inquiry) ->
    if inquiry
      valid_for_call = valid_for_call_states.indexOf(inquiry.state) != -1
      callback(valid_for_call, inquiry)
    else
      callback(false, inquiry)