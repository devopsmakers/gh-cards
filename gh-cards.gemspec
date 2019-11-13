lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gh/cards/version"

Gem::Specification.new do |spec|
  spec.name          = "gh-cards"
  spec.version       = Gh::Cards::VERSION
  spec.authors       = ["Tim Birkett"]
  spec.email         = ["tim.birkett@devopsmakers.co.uk"]

  spec.summary       = "Create HTML format cards from Github Issues for printing"
  spec.homepage      = "https://github.com/devopsmakers/gh-cards"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.5.0'

  spec.add_runtime_dependency "octokit", "~> 4.14"
  spec.add_runtime_dependency "netrc", "~> 0.11.0"
  spec.add_runtime_dependency "git", "~> 1.5"
  spec.add_runtime_dependency "thor", "~> 0.20.3"
  spec.add_runtime_dependency "activesupport", "~> 6.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
