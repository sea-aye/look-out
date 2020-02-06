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

  spec.add_dependency 'typhoeus', '~> 1.3'

  spec.add_development_dependency 'bundler', '>= 1.15', '< 3.0'
  spec.add_development_dependency 'dotenv', '~> 2.4'
  spec.add_development_dependency 'look_out'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.59'
  spec.add_development_dependency 'simplecov', '~> 0.16'
  spec.add_development_dependency 'vcr', '~> 5.0'
  spec.add_development_dependency 'webmock', '~> 3.8.1'
end
