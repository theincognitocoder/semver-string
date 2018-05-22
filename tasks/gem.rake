# frozen_string_literal: true

desc 'Builds a gem'
task 'gem' => [
  'gem:clean',
  'gem:build',
]

task 'gem:build' do
  sh('gem build semver-string.gemspec')
end

task 'gem:clean' do
  Dir.glob('*.gem').each do |gem_path|
    rm_f(gem_path)
  end
end

task 'gem:install' => ['gem:clean', 'gem:build'] do
  path = Dir.glob('*.gem').first
  sh("gem install #{path}")
end
