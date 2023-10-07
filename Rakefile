require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--require ./bonus_formatter.rb --format BonusFormatter"
end

desc "Launch tests for the book namespace"
task :int_book do
  sh "rspec -t book || true"
end

task book: [:rubocop, :int_book]
