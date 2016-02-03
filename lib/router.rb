class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  # checks if pattern matches path and method matches request method
  def matches?(req)
    path = req.path.to_s
    method = req.request_method.downcase.to_sym

    if !(@pattern =~ path).nil? && method == @http_method
      true
    else
      false
    end
  end

  # use pattern to pull out route params (save for later?)
  # instantiate controller and call controller action
  def run(req, res)
    routes = @pattern
    route_data = routes.match("#{req.path}")
    route_params = Hash.new
    route_data.names.each do |name|
      route_params[name] = route_data[name.to_sym]
    end

    controller = @controller_class.new(req, res, route_params)
    controller.invoke_action(@action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  # evaluate the proc in the context of the instance
  # for syntactic sugar :)
  def draw(&proc)
    self.instance_eval(&proc)
  end

  # make each of these methods that
  # when called add route
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      self.add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # should return the route that matches this request
  def match(req)
    @routes.select { |route| route.matches?(req) }.first
  end

  # either throw 404 or call run on a matched route
  def run(req, res)
    if self.match(req)
      self.match(req).run(req, res)
    else
      res.status = 404
    end
  end
end


# if @http_method == :get
#
#   if @pattern == /(\w.*)$/ =~ path
#     true
#   elsif @pattern == /(\w.*)\/(\d+)$/ =~ path
#     true
#   elsif @pattern == /(\w.*)\/(\d+)\(edit)$/ =~ path
#     true
#   elsif @pattern == /(\w.*)\/(new)$/ =~ path
#     true
#   else
#     false
#   end
#
# elsif @http_method == :post
#   @pattern == /(\w.*)\/$/ =~ path ? true : false
# elsif @http_method == :patch || @http_method == :put
#   @pattern == /(\w.*)\/(\d+)$/ =~ path ? true : false
# elsif @http_method == :delete
#   @pattern == /(\w.*)\/(\d+)$/ =~ path ? true : false
# else
#   false
# end
