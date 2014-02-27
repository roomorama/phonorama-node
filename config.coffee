module.exports = ->
  switch process.env.NODE_ENV
    when 'production'
      roomoramaDb:
        host: process.env.ROOMORAMA_DATABASE_HOST,
        database: process.env.ROOMORAMA_DATABASE_NAME,
        user: process.env.ROOMORAMA_DATABASE_USER,
        protocol: "mysql",
        query: { pool: true }
      zendesk:
        phone_number: '+18627666553'
    when 'staging'
      roomoramaDb:
        host: process.env.ROOMORAMA_DATABASE_HOST,
        database: process.env.ROOMORAMA_DATABASE_NAME,
        user: process.env.ROOMORAMA_DATABASE_USER,
        protocol: "mysql",
        query: { pool: true }
      zendesk:
        phone_number: '+14435525542'
    else
      zendesk:
        phone_number: '+14435525542'
      roomoramaDb:
        host: 'localhost',
        database: 'roomorama',
        user: 'root',
        port: '13306',
        protocol: "mysql",
        query: { pool: true },
        socketPath: '/opt/boxen/data/mysql/socket'

