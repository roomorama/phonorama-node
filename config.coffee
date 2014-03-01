dotenv = require 'dotenv'
dotenv.load()

configuration = ->
  switch process.env.NODE_ENV
    when 'production'
      roomoramaDb:
        database: process.env.DATABASE_NAME
        user: process.env.DATABASE_USER
        password: process.env.DATABASE_PASSWORD
        options:
          sync:
            force: false
          host: process.env.DATABASE_HOST
          dialect: "mysql"
          pool:
            maxConnections: 10
            maxIdleTime: 30
      zendesk:
        accessToken: process.env.ZENDESK_ACCESS_TOKEN
        phoneNumber: '+18627666553'
    when 'staging'
      roomoramaDb:
        database: process.env.DATABASE_NAME
        user: process.env.DATABASE_USER
        password: process.env.DATABASE_PASSWORD
        options:
          sync:
            force: false
          host: process.env.DATABASE_HOST
          dialect: "mysql"
          pool:
            maxConnections: 10
            maxIdleTime: 30
      zendesk:
        accessToken: process.env.ZENDESK_ACCESS_TOKEN
        phoneNumber: '+14435525542'
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
      zendesk:
        accessToken: process.env.ZENDESK_ACCESS_TOKEN
        phoneNumber: '+14435525542'
    else
      roomoramaDb:
        user: 'root'
        options:
          sync:
            force: true
          dialect: "sqlite"
          storage: ":memory:"
      zendesk:
        accessToken: process.env.ZENDESK_ACCESS_TOKEN
        phoneNumber: '+14435525542'
#"#{process.cwd()}/spec/fixtures/testdb.sqlite"
module.exports = configuration()