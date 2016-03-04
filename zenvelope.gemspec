lib = 'zenvelope'
lib_file = File.expand_path("../lib/#{lib}.rb", __FILE__)
File.read(lib_file) =~ /\bVERSION\s*=\s*["'](.+?)["']/
version = $1

Gem::Specification.new do |s|
  s.name        = lib
  s.version     = version

  s.summary     = 'Simple Zabbix API wrapper'
  s.description = 'A simple Ruby API wrapper for Zabbix server'
  s.authors     = %w(Nickolai Barnum)
  s.email       = 'nbarnum@users.noreply.github.com'

  s.homepage    = 'https://github.com/nbarnum/zenvelope'
  s.license     = 'MIT'
  s.files       = ['lib/zenvelope.rb']

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'faraday', '0.9'
  s.add_dependency 'net-http-persistent', '2.9'
end
