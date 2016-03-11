require 'json'

class Session

  def initialize(req)
    if req.cookies['_rails_lite_app'].nil?
      @cookie_val = {}
    else
      @cookie_val = JSON.parse(req.cookies['_rails_lite_app'])
    end
  end

  def store_session(res)
    res.set_cookie(
      '_rails_lite_app',
      { path: '/', value: @cookie_val.to_json }
    )
  end

  private

  def [](key)
    @cookie_val[key]
  end

  def []=(key, val)
    @cookie_val[key] = val
  end
end
