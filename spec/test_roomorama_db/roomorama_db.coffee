sqlite3 = require('sqlite3').verbose()
db = new sqlite3.Database(':memory:')

db.serialize ->
  db.run("CREATE TABLE inquiries (id INTEGER, state STRING)")
  db.run("INSERT into inquiries (id, state) VALUES(1,'hi')")

db.all "SELECT * from inquiries", (err, result) ->
  console.log(err, result)

module.exports = db