require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name        = "binder"
    gemspec.summary     = "A tool for rebinding your ruby procs, with a helper for DSL creaters."
    gemspec.description = "Binder allows you to evaluate a proc in a closure other than the one in which it was created." + 
                          " It also includes a method :bind to DRY up code for anyone creating a domain specific language."
    gemspec.email       = "moonmaster9000@gmail.com"
    gemspec.files       = FileList['lib/**/*.rb', 'README.rdoc']
    gemspec.homepage    = "http://github.com/moonmaster9000/binder"
    gemspec.authors     = ["Matt Parker"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
