require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/show_exceptions'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  use ShowExceptions
  run app
end.to_app

Rack::Server.start(
 app: app,
 Port: 3000
)
