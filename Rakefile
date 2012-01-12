require 'rake/testtask'

Rake::TestTask.new { |task|
  task.libs << 'tests'
  files = FileList['tests/**/test_*.rb'].to_a
  task.test_files = files
}

desc 'Run tests'
task :default => :test
