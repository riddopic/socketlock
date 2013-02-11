
$:.unshift(File.dirname(__FILE__) + '/lib')
require 'socketlock'

Gem::Specification.new do |s|
  s.name = 'socketlock'
  s.version = SocketLock::VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = false
  s.extra_rdoc_files = [ 'README.md', 'LICENSE' ]
  s.summary = 'A gem for doing concurrency locks using a TCP port.'
  s.description = s.summary
  s.authors = [ 'Tom Santos', 'Stefano Harding' ]
  s.email = [ 'santos.tom@gmail.com', 'riddopic@gmail.com' ]
  s.homepage = 'http://github.com/riddopic/socketlock'
  
  s.require_path = 'lib'
  s.files = %w(Rakefile LICENSE README.md) + Dir.glob("{distro,lib,tasks,spec}/**/*")
end
