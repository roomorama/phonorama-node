_ = require "#{process.cwd()}/lib/underscore"

helper =
  inquiryIdField: (ticket) ->
    _.find ticket.custom_fields, (field) ->
      field.id == 21120254

module.exports = helper