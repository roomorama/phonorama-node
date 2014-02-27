module.exports = ->
  switch process.env.NODE_ENV
    when 'production'
      zendesk:
        phone_number: '+18627666553'
    when 'staging'
      zendesk:
        phone_number: '+14435525542'
    else
      zendesk:
        phone_number: '+14435525542'