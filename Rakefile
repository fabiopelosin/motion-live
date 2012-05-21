desc "Build the gem"
task :gem do
  sh "bundle exec gem build motion-live.gemspec"
  sh "mkdir -p pkg"
  sh "mv *.gem pkg/"
end

task :clean do
  FileUtils.rm_rf 'pkg'
end

desc "Install the gem"
task :install => %w[ clean gem ] do
  sh "sudo gem install pkg/motion-live*.gem"
end
