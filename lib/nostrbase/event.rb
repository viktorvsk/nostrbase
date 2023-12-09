module Nostrbase
  class Event
    attr_reader :id, :pubkey, :created_at, :kind, :tags, :content, :sig, :errors

    def self.sign_keys
      @keys ||= Keys.new
    end

    def self.sign_secret=(secret_hex)
      @keys = Keys.new(secret_hex)
    end

    def initialize(hash_or_json_payload)
      payload = hash_or_json_payload.is_a?(Hash) ? hash_or_json_payload.map { |key, v| [key.to_s, v] }.to_h : JSON.parse(hash_or_json_payload)

      @id = payload["id"]
      @pubkey = payload["pubkey"]
      @created_at = payload["created_at"]
      @kind = payload["kind"]
      @tags = payload["tags"]
      @content = payload["content"]
      @sig = payload["sig"]

      @raw_payload = hash_or_json_payload
      @errors = []
    end

    def signed?
      sig.to_s.length.positive? && id.to_s.length.positive? && pubkey.to_s.length.positive?
    end

    def sign(allow_resign: false, keys: nil)
      return false if signed? && !allow_resign

      keys = self.class.sign_keys if keys.nil?

      @pubkey = keys.public
      @id = Digest::SHA256.hexdigest(JSON.dump(to_nostr_serialized))
      @sig = keys.sign(id)
    end

    def sign!(keys: nil)
      raise AlreadySigned, "Can't signed event that already has sig, id or pubkey present" if signed?
      sign(keys: keys)
    end

    def resign(keys: nil)
      sign(allow_resign: true, keys: keys)
    end

    def valid_schema?
      @errors = NostrEventSchema.validate(@raw_payload)
      @errors.size.negative?
    end

    def valid_id?
      Digest::SHA256.hexdigest(JSON.dump(to_nostr_serialized)) === id
    end

    def valid_signature?
      schnorr_sig = Secp256k1::SchnorrSignature.from_data([sig].pack("H*"))
      schnorr_pubkey = Secp256k1::XOnlyPublicKey.from_data([pubkey].pack("H*"))

      schnorr_sig.verify([id].pack("H*"), schnorr_pubkey)
    rescue Secp256k1::DeserializationError
      false
    end

    def to_nostr_serialized
      [
        0,
        pubkey,
        created_at.to_i,
        kind.to_i,
        tags,
        content.to_s
      ]
    end

    def as_json
      {
        id:,
        pubkey:,
        created_at:,
        kind:,
        tags:,
        content:,
        sig:
      }
    end
  end
end
