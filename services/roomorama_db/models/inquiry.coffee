class Inquiry
  constructor: ->

  define: (db) ->
    db.define 'inquiries',
              id: {type: "number"},
              state: {type: "text"}

module.exports = new Inquiry()