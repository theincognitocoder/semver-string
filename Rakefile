# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))

Dir.glob('tasks/**/*.rake').each do |task_file|
  load(task_file)
end

desc 'Removes built docs, gems, and test files'
task 'clean' => [
  'test:clean',
  'docs:clean',
  'gem:clean',
]

task 'build' => [
  'test',
  'rubocop',
  'docs',
  'gem',
]

task 'default' => [
  'test',
  'rubocop',
]
