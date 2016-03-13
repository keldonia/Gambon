# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name                = "gambom"
  s.version             = "0.1.0"
  s.summary             = %q(Gambon is lightweight MVC framework with a built-in in ORM)
  s.description         = %q(Gambon is lightweight MVC framework with a built-in in ORM that allows for updates to a Postgres database to be run without much additional SQL code.)
  s.author              = "Brian Lambert"
  s.email               = "brian.joseth.lambert@gmail.com"
  s.homepage            = "https://github.com/keldonia/Gambon"
  s.license             = 'MIT'

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }

  s.executables  << "gambom"

  s.add_runtime_dependency 'thor', '~>0.19'
  s.add_runtime_dependency "pg", '~>0.18'
  s.add_runtime_dependency "activesupport", '~>4.2'
  s.add_runtime_dependency "pry", '~>0.10'
  s.add_runtime_dependency "rack", '~>1.6'

  s.add_runtime_dependency "bundler", "~>1.11"
  s.add_runtime_dependency "rake", "~>0.9"
  s.add_runtime_dependency "rspec", "~>3"

end
