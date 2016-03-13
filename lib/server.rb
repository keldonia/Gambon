require 'rack'
require 'erb'
require_relative './router'
require_relative './controller_base'
require_relative './show_exceptions'
require_relative './static'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use ShowExceptions
  use Static
  run app
end.to_app

Rack::Server.start(
 app: app,
 Port: 3000
)
