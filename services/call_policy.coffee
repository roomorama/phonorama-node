roomoramaDb = require './roomorama_db'
logger = require "#{process.cwd()}/lib/custom_logger"

exports.inquiryValidForCall = (inquiry_id, callback) ->
  logger.info "db lookup: #{inquiry_id}"
  roomoramaDb.Inquiry.find(inquiry_id).success (inquiry) ->
    if inquiry
      valid_for_call = true
      callback(valid_for_call, inquiry)
    else
      callback(false, inquiry)
