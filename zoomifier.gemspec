require 'rubygems'
spec = Gem::Specification.new do |s|
  s.name = 'Zoomifier'
  s.version = '1.1'
  s.author = 'Donald Ball'
  s.email = 'donald.ball@gmail.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A library for zoomifying images'
  s.files = ['lib/zoomifier.rb', 'bin/zoomify']
  s.require_path = 'lib'
  s.autorequire = 'zoomifier'
  s.bindir = 'bin'
  s.executables = ['zoomify']
  s.default_executable = 'zoomify'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.txt']
  s.add_dependency('rmagick')
end

if $0 == __FILE__
  Gem::manage_gems
  Gem::Builder.new(spec).build
end
