# frozen_string_literal: true

require "json"
require "digest"
require "json_schemer"
require "rbsecp256k1"

require_relative "nostrbase/version"

require_relative "nostrbase/nostr_event_schema"
require_relative "nostrbase/event"
require_relative "nostrbase/keys"

module Nostrbase
  class AlreadySigned < StandardError; end
end
