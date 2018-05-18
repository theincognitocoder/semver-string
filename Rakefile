# frozen_string_literal: true

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
  'docs:build',
  'gem:build',
]

task 'default' => [
  'test',
  'rubocop',
]
