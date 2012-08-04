#!/usr/bin/env rake

task :travis_lint do |t|
  sh 'travis-lint'
end
