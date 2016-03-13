lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name                = "gambon"
  s.version             = "0.1.0"
  s.summary             = %q(Gambon is lightweight MVC framework with a built-in in ORM)
  s.description         = %q(Gambon is lightweight MVC framework with a built-in in ORM that allows for updates to a Postgres database to be run without much additional SQL code.)
  s.author              = "Brian Lambert"
  s.email               = "brian.joseth.lambert@gmail.com"
  s.homepage            = "https://github.com/keldonia/Gambon"
  s.license             = 'MIT'


  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)}) }
  s.executables   = "gambon"

  s.add_runtime_dependency "thor"
  s.add_runtime_dependency "pg"
  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "pry"
  s.add_runtime_dependency "rack"
  s.add_runtime_dependency "fileutils"

  s.add_runtime_dependency "bundle"
  s.add_runtime_dependency "rake"
  s.add_runtime_dependency "rspec"


end
