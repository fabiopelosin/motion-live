Gem::Specification.new do |s|
  s.name        = 'motion-live'
  s.version     = '0.1'
  s.date        = Date.today
  s.summary     = 'Live coding for RubyMotion projects.'
  s.description = 'Write you code in a scratch pad file and have the changes reflected in your application running in the simulator. Suited for prototyping user interfaces.'
  s.author      = 'Fabio Angelo Pelosin'
  s.email       = 'fabiopelosin@gmail.com'
  s.homepage    = 'https://github.com/irrationalfab/motion-live'
  s.files       = Dir.glob('lib/**/*.rb') << 'README.md' << 'LICENSE'

  s.add_runtime_dependency 'colored',    '~> 1.2'
  s.add_runtime_dependency 'rb-fsevent', '~> 0.9.1'
end
