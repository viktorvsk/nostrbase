# frozen_string_literal: true

require_relative "lib/nostrbase/version"

Gem::Specification.new do |spec|
  spec.name = "nostrbase"
  spec.version = Nostrbase::VERSION
  spec.authors = ["Viktor Vsk"]
  spec.email = ["me@viktorvsk.com"]

  spec.summary = "Simple Nostr keys and events management"
  spec.description = "Create private and public keys, sign events and validate their signature and schema"
  spec.homepage = "https://saltivka.org"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://saltivka.org"
  spec.metadata["changelog_uri"] = "https://saltivka.org"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rbsecp256k1", "~> 6"
  spec.add_dependency "json_schemer", "~> 2"
end
