require 'rake'

Gem::Specification.new do |s|
  s.name = 'coral'
  s.version = '0.0.0'
  s.licenses = ['MIT']
  s.summary = 'A custom shell made in Ruby'
  s.description = 'A custom shell made in Ruby with a process time manager and a file watcher'
  s.authors = ['Ryan Furrer']
  s.email = 'rfurrer@ualberta.ca'
  s.homepage = 'https://github.com/rubynetix/coral'

  s.files = FileList['lib/*.rb'].to_a
  s.test_files = FileList['test/*_test.rb'].to_a
end