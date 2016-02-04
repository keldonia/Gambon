require 'json'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    if req.cookies['_rails_lite_app'].nil?
      @cookie_val = {}
    else
      @cookie_val = JSON.parse(req.cookies['_rails_lite_app'])
    end
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
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
