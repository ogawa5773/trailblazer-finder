require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--format documentation --format RspecJunitFormatter --out test-reports/spec.xml"
end
RSpec::Core::RakeTask.new(:tests) do |t|
  t.rspec_opts = "--format progress --format documentation"
end
RSpec::Core::RakeTask.new(:spec_report) do |t|
  t.rspec_opts = "--format html --out reports/rspec_results.html"
end

RuboCop::RakeTask.new(:rubocop)

desc "Remove temporary files"
task :clean do
  `rm -rf *.gem doc pkg coverage test-reports`
  %x(rm -f `find . -name '*.rbc'`)
end

desc "Build the gem"
task :gem do
  `gem build trailblazer-finder.gemspec`
end

desc "Running Tests"
task default: %i[spec rubocop]
