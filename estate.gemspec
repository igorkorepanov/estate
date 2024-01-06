require_relative 'lib/estate/version'

Gem::Specification.new do |s|
  s.name        = "estate"
  s.version     = Estate::VERSION
  s.summary     = "Estate"
  s.description = "Estate test gem"
  s.authors     = ["Igor Korepanov"]
  s.email       = "email@example.com"
  s.files       = Dir.glob('{lib}/**/*') + %w(LICENSE.txt README.md)
  s.homepage    = "https://rubygems.org/gems/estate"
  s.license     = "MIT"

  # s.add_development_dependency 'rspec'
end