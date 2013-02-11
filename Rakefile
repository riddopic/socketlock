
require File.dirname(__FILE__) + '/lib/socketlock'

require 'rubygems'
require 'rubygems/package_task'
require 'rdoc/task'
require 'rake/clean'

GEM_NAME = 'socketlock'

spec = eval(File.read('socketlock.gemspec'))

Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

begin
  require 'sdoc'

  Rake::RDocTask.new do |rdoc|
    rdoc.title = "SocketLock Ruby API Documentation"
    rdoc.main = "README.rdoc"
    rdoc.options << '--fmt' << 'shtml' # explictly set shtml generator
    rdoc.template = 'direct' # lighter template
    rdoc.rdoc_files.include("README.rdoc", "LICENSE", "lib/**/*.rb")
    rdoc.rdoc_dir = "rdoc"
  end
rescue LoadError
  puts "sdoc is not available. (sudo) gem install sdoc to generate rdoc documentation."
end

desc "Install the gem locally"
task :install => :package do
  sh %{ gem install pkg/#{GEM_NAME}-#{SocketLock::VERSION} --no-rdoc --no-ri }
end

desc "Uninstall the gem locally"
task :uninstall do
  sh %{ gem uninstall #{GEM_NAME} -x -v #{SocketLock::VERSION} }
end

desc "Pushes the gem to rubygems.org"
task :push => :gem do |t|
  sh %{ gem push pkg/#{GEM_NAME}-#{SocketLock::VERSION}.gem }
end

task :default => :gem

CLEAN.include 'pkg'
