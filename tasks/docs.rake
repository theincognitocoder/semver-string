# frozen_string_literal: true

desc 'Builds the documentation'
task 'docs:build' do
  sh('yard')
end

task 'docs:clean' do
  rm_rf('.yardoc')
  rm_rf('docs')
  rm_rf('docs.tgz')
end

task 'docs:tgz' do
  sh('tar czf docs.tgz docs/')
end
