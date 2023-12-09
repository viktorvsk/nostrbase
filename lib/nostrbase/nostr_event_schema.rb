module Nostrbase
  class NostrEventSchema
    SCHEMA = JSONSchemer.schema({
      "$schema": "http://json-schema.org/draft-07/schema#",
      id: "nostr/nips/01/commands/client/EVENT/event/",
      type: "object",
      required: %w[content created_at id kind pubkey sig tags],
      properties: {
        content: {
          type: "string",
          id: "content"
        },
        created_at: {
          type: "intger",
          id: "created_at",
          minimum: 0
        },
        id: {
          type: "string",
          id: "id",
          minLength: 64,
          maxLength: 64
        },
        kind: {
          type: "integer",
          id: "kind",
          minimum: 0,
          maxumum: 65535
        },
        pubkey: {
          type: "string",
          id: "pubkey",
          minLength: 64,
          maxLength: 64
        },
        sig: {
          type: "string",
          id: "sig",
          minLength: 128,
          maxLength: 128
        },
        tags: {
          type: "array",
          id: "tags/",
          items: [
            {
              type: "array",
              prefixItems: {
                type: "string",
                minLength: 1
              },
              minLength: 1
            }
          ]
        }
      }

    }.to_json)

    def self.validate(payload)
      errors = []

      SCHEMA.validate(payload).each { |error| errors.push(key: error["data_pointer"], value: JSONSchemer::Errors.pretty(error)) }

      errors
    end
  end
end
