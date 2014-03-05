zendesk = require("#{process.cwd()}/services/zendesk")

helper = zendesk.helper
apiClient = zendesk.apiClient
ticket = zendesk.ticket

xdescribe "ticket", ->
  describe "close", ->
    it "closes the ticket with specified id", (done) ->
      spyOn(apiClient, 'save').andCallFake (callback) ->
        true

      zendesk.ticket.close(id)
