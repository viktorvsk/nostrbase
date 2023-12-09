module Nostrbase
  class Keys
    attr_reader :secret, :public

    CONTEXT = Secp256k1::Context.create

    def initialize(secret_hex = nil)
      private_key_data = secret_hex ? Secp256k1::Util.hex_to_bin(secret_hex) : SecureRandom.random_bytes(32)
      @secret = Secp256k1::Util.bin_to_hex(Secp256k1::PrivateKey.from_data(private_key_data).data)
      @key_pair = CONTEXT.key_pair_from_private_key(private_key_data)

      # Nostr ignores first byte of pubkey, more details here https://bips.xyz/340
      @public = Secp256k1::Util.bin_to_hex(@key_pair.public_key.compressed)[2..]
    end

    def sign(message)
      CONTEXT.sign_schnorr(@key_pair, [message].pack("H*")).serialized.unpack1("H*")
    end
  end
end
