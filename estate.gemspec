# frozen_string_literal: true

require_relative 'lib/estate/version'

Gem::Specification.new do |s|
  s.name        = 'estate'
  s.version     = Estate::VERSION
  s.summary     = 'State machine for Rails models'
  s.description = 'Estate is a Ruby gem designed to simplify state management in ActiveRecord models'
  s.authors     = ['Igor Korepanov']
  s.email       = 'noemail@example.com'
  s.files       = Dir.glob('{lib}/**/*') + %w[LICENSE.txt README.md]
  s.homepage    = 'https://github.com/igorkorepanov/estate'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.7'

  s.add_development_dependency 'rspec', '3.12.0'
end
