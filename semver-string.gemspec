# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'semver-string'
  spec.version       = File.read(File.expand_path('VERSION', __dir__)).strip
  spec.summary       = 'Semver v2.0 version strings in Ruby.'
  spec.authors       = ['The Incognito Coder']
  spec.email         = ['theincognitocoder@gmail.com']
  spec.homepage      = 'https://github.com/theincognitocoder/semver-string'
  spec.license       = 'MIT'
  spec.require_paths = ['lib']
  spec.files         = Dir['lib/**/*.rb']

  spec.metadata = {
    'bug_tracker_uri'   => 'https://github.com/theincognitocoder/semver-string/issues',
    'changelog_uri'     => 'https://github.com/theincognitocoder/semver-string/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/github/theincognitocoder/semver-string/master',
    'homepage_uri'      => 'https://github.com/theincognitocoder/semver-string',
    'mailing_list_uri'  => 'https://gitter.im/theincognitocoder/semver-string',
    'source_code_uri'   => 'https://github.com/theincognitocoder/semver-string',
    'wiki_uri'          => 'https://github.com/theincognitocoder/semver-string/wiki',
  }

  spec.add_development_dependency('coveralls', '~> 0.8')
  spec.add_development_dependency('kramdown', '~> 1.16')
  spec.add_development_dependency('pry', '~> 0.11')
  spec.add_development_dependency('rake', '~> 12.3')
  spec.add_development_dependency('rspec', '~> 3.7')
  spec.add_development_dependency('rubocop', '~> 0.56')
  spec.add_development_dependency('yard', '~> 0.9')
  spec.add_development_dependency('yard-sitemap', '~> 1.0')
end
