require 'rubygems/package_task'
require 'rake/testtask'

spec = Gem::Specification.load 'oaktree.gemspec'

desc 'Run tests'
Rake::TestTask.new { |task|
  task.libs << 'test'
  files = FileList['test/**/test_*.rb'].to_a
  task.test_files = files
}

desc "Build #{spec.name} #{spec.version.to_s}"
Gem::PackageTask.new(spec) { |task|
  task.need_zip = true
}

task :default => :test
