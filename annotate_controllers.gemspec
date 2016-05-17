# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'annotate_controllers/version'

Gem::Specification.new do |s|
  s.name          = 'annotate_controllers'
  s.version       = AnnotateControllers::VERSION
  s.authors       = ['Michael Michaelevich']
  s.description   = 'Annotate Rails controllers with routes information.'
  s.email         = ['monkeysquirrel7@gmail.com']
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.files         = `git ls-files -z`.split("\x0")
  s.homepage      = 'https://github.com/mmichael0413/annotate_controllers'
  s.license       = 'MIT'
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 1.9.3'
  s.summary       = 'Annotate Rails controllers'
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.add_development_dependency 'bundler', '~> 1.12.3'
  s.add_development_dependency 'rake', '~> 11.1.2'

  s.add_dependency 'rails', '> 4.2'
end
