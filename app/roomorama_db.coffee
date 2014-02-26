require('mysql')
orm = require('orm')
fs = require('fs')

class RoomoramaDb
  constructor: ->

  connect: ->
    self = @
    db = orm.connect
      host: "localhost",
      database: "roomorama",
      user: "root",
      post: '13306',
      protocol: "mysql",
      query: { pool: true },
      socketPath: '/opt/boxen/data/mysql/socket'

    db.on "connect", (err) ->
      self.defineModels(db)

  defineModels: (db) ->
    models = fs.readdirSync(process.cwd()+'/app/models')
    models.forEach (filename) ->
      modelName = @camelize(filename)
      model = require('./models/' + filename)
      @[modelName] = model.define(db)
    , @

  camelize: (string) ->
    string.replace(/\..*/,'').split(/[\W_-]/).map (pieces) ->
      pieces.charAt(0).toUpperCase() + pieces.slice(1)
    .join("")
module.exports = new RoomoramaDb()