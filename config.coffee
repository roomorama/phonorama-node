env = require('./opsworks').customEnvironment

configuration = ->
  switch env.app.NODE_ENV
    when 'production'
      roomoramaDb:
        database: env.roomorama_db.DATABASE_NAME
        user: env.roomorama_db.DATABASE_USER
        password: env.roomorama_db.DATABASE_PASSWORD
        options:
          sync:
            force: false
          host: env.roomorama_db.DATABASE_HOST
          dialect: "mysql"
          pool:
            maxConnections: 10
            maxIdleTime: 30
      roomoramaAPI:
        accessToken: env.roomorama_api.ROOMORAMA_ACCESS_TOKEN
        host: 'https://api.roomorama.com/'
      zendesk:
        accessToken: env.zendesk.ZENDESK_ACCESS_TOKEN
        supportNumber: '+18627666553'
        conversionNumber: '+18627666551'
      rollbar:
        post_server_item_access_token: env.rollbar.ROLLBAR_POST_SERVER_ACCESS_TOKEN
    when 'staging'
      roomoramaDb:
        database: env.roomorama_db.DATABASE_NAME
        user: env.roomorama_db.DATABASE_USER
        password: env.roomorama_db.DATABASE_PASSWORD
        options:
          sync:
            force: false
          host: env.roomorama_db.DATABASE_HOST
          dialect: "mysql"
          pool:
            maxConnections: 10
            maxIdleTime: 30
      roomoramaAPI:
        accessToken: env.roomorama_api.ROOMORAMA_ACCESS_TOKEN
        host: 'https://api.staging.roomorama.com/'
      zendesk:
        accessToken: env.roomorama_zendesk.ZENDESK_ACCESS_TOKEN
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
        accessToken: env.roomorama_api.ROOMORAMA_ACCESS_TOKEN
        host: 'http://api.roomorama.dev/'
      zendesk:
        accessToken: env.roomorama_zendesk.ZENDESK_ACCESS_TOKEN
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
        accessToken: env.roomorama_api.ROOMORAMA_ACCESS_TOKEN
        host: 'http://api.roomorama.dev/'
      zendesk:
        accessToken: env.roomorama_zendesk.ZENDESK_ACCESS_TOKEN
        phoneNumber: '+14435525542'
        conversionNumber: '+14435525542'

module.exports = configuration()