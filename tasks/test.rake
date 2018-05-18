desc 'Runs the test suite'
task 'test' => [
  'test:clean',
  'test:spec',
]

task 'test:clean' do
  rm_rf('coverage')
end

desc 'Runs spec tests'
task 'test:spec' do
  sh('bundle exec rspec')
end
