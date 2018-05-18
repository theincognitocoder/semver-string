desc 'Releases a new version of semver-string'
task 'release' => [
  'release:require-version',
  'release:require-clean-workspace',
  'test',
  'release:changelog',
  'release:tag',
  'release:push',
]

task 'release:require-version' do
  if ENV['VERSION'].to_s.empty?
    warn("usage: VERSION=x.y.z rake release")
    exit(1)
  end
  begin
    $VERSION = Version.new(ENV['VERSION'])
  rescue Version::InvalidFormatError => e
    warn("ENV['VERSION'] #{e.message}")
    exit(1)
  end
end

task 'release:require-clean-workspace' do
  unless `git diff --shortstat 2> /dev/null | tail -n1` == ''
    warn('workspace must be clean to release')
    exit(1)
  end
end

task 'release:changelog' => ['release:require-version'] do
  changelog = File.read('CHANGELOG.md').lines
  changelog = changelog[0..4] + [nil, nil, nil] + changelog[5..-1]
  changelog[5] = "v#{$VERSION} (#{Time.now.strftime('%Y-%m-%d')})\n"
  changelog[6] = '-' * (changelog[5].chars.count) + "\n"
  changelog[7] = "\n"
  File.write('CHANGELOG.md', changelog.join)
  sh('git add CHANGELOG.md')
end

task 'release:tag' => ['release:require-version'] do
  File.write('VERSION',"#{$VERSION}\n")
  issues = `git log $(git describe --tags --abbrev=0)...HEAD -E --grep '#[0-9]+' 2>/dev/null`
  issues = issues.scan(/((?:\S+\/\S+)?#\d+)/).flatten
  msg = "Tag release v#{$VERSION}\n\n"
  unless issues.empty?
    msg += "References: #{issues.uniq.sort.join(', ')}\n\n"
  end
  sh('git add VERSION')
  sh("git commit -m \"Bump version to v#{$VERSION}\"")
  sh("git tag -a -m #{msg.inspect} v#{$VERSION}")
end

task 'release:push' do
  sh('git push origin')
  sh('git push origin --tags')
end
