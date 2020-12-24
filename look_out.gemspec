lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'look_out/version'

Gem::Specification.new do |spec|
  spec.name          = 'look_out'
  spec.version       = LookOut::VERSION
  spec.authors       = ['Andrew Hood']
  spec.email         = ['andrewhood125@gmail.com']

  spec.summary       = 'In charge of the observation of the code for hazards.'
  spec.description   = 'In charge of the observation of the code for hazards.'
  spec.homepage      = 'https://github.com/sea-aye/look-out'

  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'typhoeus'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
