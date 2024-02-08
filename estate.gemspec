# frozen_string_literal: true

require_relative 'lib/estate/version'

Gem::Specification.new do |s|
  s.name        = 'estate'
  s.version     = Estate::VERSION
  s.summary     = 'State machine for Rails models and plain Ruby objects'
  s.description = 'Estate is a Ruby gem designed to simplify state management in models, as well as plain Ruby objects'
  s.authors     = ['Igor Korepanov']
  s.email       = 'korepanovigor87@gmail.com'
  s.files       = Dir.glob('{lib}/**/*') + %w[LICENSE.txt README.md]
  s.homepage    = 'https://github.com/igorkorepanov/estate'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.7'

  s.add_development_dependency 'rubocop', '1.59.0'
  s.add_development_dependency 'rubocop-performance', '1.20.2'
  s.add_development_dependency 'rubocop-rspec', '2.26.1'

  s.add_development_dependency 'rspec', '3.12.0'

  s.add_development_dependency 'simplecov', '0.22.0'
end
