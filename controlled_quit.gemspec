# -*- encoding: utf-8 -*-
require File.expand_path('../lib/controlled_quit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Jack Foy']
  gem.email         = ['jack@foys.net']
  gem.description   = %q{Gem to support controlled shutdown from long-running command-line tools}
  gem.summary       = %q{Support controlled shutdown}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'controlled_quit'
  gem.require_paths = ['lib']
  gem.version       = ControlledQuit::VERSION
end
