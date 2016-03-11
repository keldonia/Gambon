require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, hash={})
    @req = req
    @res = res
    @params = req.params.merge(hash)
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise "Double Render" if already_built_response?
    @already_built_response = true
    @res.status = 302
    @res['Location'] = url
    session.store_session(@res)
  end

  def render_content(content, content_type)
    raise "Double Render" if already_built_response?
    @already_built_response = true
    @res.write("#{content}")
    @res['Content-Type'] = content_type
    session.store_session(@res)
  end

  def render(template_name)
    controller_name_regexed = self.class.to_s.match /(\w.*)/
    controller_name = controller_name_regexed[1].underscore

    template = ERB.new(File.read(
      "views/#{controller_name}/#{template_name}.html.erb")
    )
    result = template.result(binding)
    render_content(result, 'text/html')
  end

  def session
    @session ||= Session.new(@req)
  end

  def invoke_action(name)

    self.send(name)
    render(name.to_s) unless already_built_response?
  end
end
