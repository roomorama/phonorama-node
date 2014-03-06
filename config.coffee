env = require('./opsworks').customEnvironment
process.env.NODE_ENV = env.NODE_ENV unless process.env.NODE_ENV

configuration = ->
  switch process.env.NODE_ENV
    when 'production'
      roomoramaDb:
        database: env.DATABASE_NAME
        user: env.DATABASE_USER
        password: env.DATABASE_PASSWORD
        options:
          sync:
            force: false
          host: env.DATABASE_HOST
          dialect: "mysql"
          pool:
            maxConnections: 10
            maxIdleTime: 30
      roomoramaAPI:
        accessToken: env.ROOMORAMA_ACCESS_TOKEN
        host: 'https://api.roomorama.com/'
      zendesk:
        accessToken: env.ZENDESK_ACCESS_TOKEN
        supportNumber: '+18627666553'
        conversionNumber: '+18627666551'
      rollbar:
        post_server_item_access_token: env.ROLLBAR_POST_SERVER_ACCESS_TOKEN
    when 'staging'
      roomoramaDb:
        database: env.DATABASE_NAME
        user: env.DATABASE_USER
        password: env.DATABASE_PASSWORD
        options:
          sync:
            force: false
          host: env.DATABASE_HOST
          dialect: "mysql"
          pool:
            maxConnections: 10
            maxIdleTime: 30
      roomoramaAPI:
        accessToken: env.ROOMORAMA_ACCESS_TOKEN
        host: 'https://api.staging.roomorama.com/'
      zendesk:
        accessToken: env.ZENDESK_ACCESS_TOKEN
        phoneNumber: '+14435525542'
        conversionNumber: '+14435525542'
    when 'development'
      roomoramaDb:
        database: 'roomorama'
        user: 'root'
        options:
          sync:
            force: false
          port: '13306'
          host: 'localhost'
          dialect: "mysql"
          pool:
            maxConnections: 10
            maxIdleTime: 30
      roomoramaAPI:
        accessToken: env.ROOMORAMA_ACCESS_TOKEN
        host: 'http://api.roomorama.dev/'
      zendesk:
        accessToken: env.ZENDESK_ACCESS_TOKEN
        phoneNumber: '+14435525542'
        conversionNumber: '+14435525542'
    else
      roomoramaDb:
        user: 'root'
        options:
          sync:
            force: true
          dialect: "sqlite"
          storage: ":memory:"
      roomoramaAPI:
        accessToken: env.ROOMORAMA_ACCESS_TOKEN
        host: 'http://api.roomorama.dev/'
      zendesk:
        accessToken: env.ZENDESK_ACCESS_TOKEN
        phoneNumber: '+14435525542'
        conversionNumber: '+14435525542'

module.exports = configuration()