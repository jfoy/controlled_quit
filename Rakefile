#!/usr/bin/env rake
Dir.glob('tasks/*.rake').each { |r| import r }

task :default => [:spec, :travis_lint]
