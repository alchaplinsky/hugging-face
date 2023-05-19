# frozen_string_literal: true

require_relative "lib/hugging_face/version"

Gem::Specification.new do |spec|
  spec.name = "hugging-face"
  spec.version = HuggingFace::VERSION
  spec.authors = ["Alex Chaplinsky"]
  spec.email = ["alchaplinsky@gmail.com"]

  spec.summary = "Ruby client for Hugging Face API"
  spec.description = "Ruby client for Hugging Face API"
  spec.homepage = "https://rubygems.org/gems/hugging-face"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/alchaplinsky/hugging-face"
  spec.metadata["changelog_uri"] = "https://github.com/alchaplinsky/hugging-face/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "faraday", ">= 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
