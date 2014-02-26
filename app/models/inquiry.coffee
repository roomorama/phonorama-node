class Inquiry
  valid_for_call_states: ["cancelled", "guest_to_pay", "host_to_confirm"]

  constructor: ->

  define: (db) ->
    self = @
    db.define 'inquiries',
            (id: {type: "number"}, state: {type: "text"}),
            (methods:
              valid_for_call: ->
                self.valid_for_call_states.indexOf(@state) != -1)

module.exports = new Inquiry()