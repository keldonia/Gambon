class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    path = req.path.to_s
    method = req.request_method.downcase.to_sym

    if !(@pattern =~ path).nil? && method == @http_method
      true
    else
      false
    end
  end

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

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      self.add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    @routes.select { |route| route.matches?(req) }.first
  end

  def run(req, res)
    matched_route = self.match(req)
    params = req.params

    if matched_route && matched_route.http_method == :get
      self.match(req).run(req, res)
    elsif matched_route && matched_route.http_method != :get

      token_from_cookie = req.cookies.find do |cookie|
        cookie.name = '_authenticity_token_rails_lite_app'
      end

      if token_from_cookie && params[:form_token] == JSON.parse(token_from_cookie.value)['authenticity_token']
        matched_route.run(req,res)
      else
        raise "No Authenticity Token"
      end
    else
      res.status = 404
    end
  end
end
