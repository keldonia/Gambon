require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, hash={})
    @req = req
    @res = res
    @params = req.params.merge(hash)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Double Render" if already_built_response?
    @already_built_response = true
    @res.status = 302
    @res['Location'] = url
    session.store_session(@res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Double Render" if already_built_response?
    @already_built_response = true
    @res.write("#{content}")
    @res['Content-Type'] = content_type
    session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    controller_name_regexed = self.class.to_s.match /(\w.*)/
    controller_name = controller_name_regexed[1].underscore

    template = ERB.new(File.read(
      "views/#{controller_name}/#{template_name}.html.erb")
    )
    result = template.result(binding)
    render_content(result, 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)

    self.send(name)
    render(name.to_s) unless already_built_response?
  end
end
