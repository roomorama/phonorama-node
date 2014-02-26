module.exports = ->
  switch process.env.NODE_ENV
    when 'production':
      zendesk:
        phone_number: '+18627666553'
    else
      zendesk:
        phone_number: '+14435525542'

