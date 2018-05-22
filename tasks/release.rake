# frozen_string_literal: true

require 'semver-string'

def version
  if ENV['VERSION'].to_s.empty?
    warn('usage: VERSION=x.y.z rake release')
    exit(1)
  end
  begin
    Semver::String.parse(ENV['VERSION'])
  rescue Semver::String::InvalidFormatError => e
    warn("ENV['VERSION'] #{e.message}")
    exit(1)
  end
end

desc 'Releases a new version of semver-string'
task 'release' => [
  'release:require-clean-workspace',
  'test',
  'release:changelog',
  'release:tag',
  'release:push',
]

task 'release:require-clean-workspace' do
  unless `git diff --shortstat 2> /dev/null | tail -n1` == ''
    warn('workspace must be clean to release')
    exit(1)
  end
end

task 'release:changelog' do
  changelog = File.read('CHANGELOG.md').lines
  changelog = changelog[0..4] + [nil, nil, nil] + changelog[5..-1]
  changelog[5] = "v#{version} (#{Time.now.strftime('%Y-%m-%d')})\n"
  changelog[6] = '-' * changelog[5].chars.count + "\n"
  changelog[7] = "\n"
  File.write('CHANGELOG.md', changelog.join)
  sh('git add CHANGELOG.md')
end

task 'release:tag' do
  File.write('VERSION', "#{version}\n")
  git_cmd = '$(git describe --tags --abbrev=0)'
  git_cmd = "git log #{git_cmd}...HEAD -E --grep '#[0-9]+' 2>/dev/null"
  issues = `#{git_cmd}`.scan(%r{((?:\S+/\S+)?#\d+)}).flatten
  msg = "Tag release v#{version}"
  msg += "\n\nReferences: #{issues.uniq.sort.join(', ')}" unless issues.empty?
  sh('git add VERSION')
  sh("git commit -m \"Bump version to v#{version}\"")
  sh("git tag -a -m #{msg.inspect} v#{version}")
end

task 'release:push' do
  sh('git push origin')
  sh('git push origin --tags')
end
