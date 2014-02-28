dotenv = require 'dotenv'
dotenv.load()

configuration = ->
  switch process.env.NODE_ENV
    when 'production'
      roomoramaDb:
        host: process.env.DATABASE_HOST
        database: process.env.DATABASE_NAME
        user: process.env.DATABASE_USER
        protocol: "mysql"
        query: { pool: true }
      zendesk:
        accessToken: process.env.ZENDESK_ACCESS_TOKEN
        phoneNumber: '+18627666553'
    when 'staging'
      roomoramaDb:
        host: process.env.DATABASE_HOST
        database: process.env.DATABASE_NAME
        user: process.env.DATABASE_USER
        protocol: "mysql"
        query: { pool: true }
      zendesk:
        accessToken: process.env.ZENDESK_ACCESS_TOKEN
        phoneNumber: '+14435525542'
    else
      roomoramaDb:
        host: 'localhost'
        database: 'roomorama'
        user: 'root'
        port: '13306'
        protocol: "mysql"
        query: { pool: true }
      zendesk:
        accessToken: process.env.ZENDESK_ACCESS_TOKEN
        phoneNumber: '+14435525542'

module.exports = configuration()