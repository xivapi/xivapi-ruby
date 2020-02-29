
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "xivapi/version"

Gem::Specification.new do |spec|
  spec.name          = "xivapi"
  spec.version       = XIVAPI::VERSION
  spec.authors       = ["Matt Antonelli"]
  spec.email         = ["contact@raelys.com"]

  spec.summary       = %q{A Ruby library for XIVAPI}
  spec.description   = %q{A Ruby library for XIVAPI (http://www.xivapi.com)}
  spec.homepage      = "https://github.com/xivapi/xivapi-ruby"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "yard", "~> 0.9.19"
  spec.add_dependency "rest-client", "~> 2.0"
end
