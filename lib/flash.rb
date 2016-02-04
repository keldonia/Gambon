require 'json'

class Flash
  attr_accessor :flash

  def initialize(req, count=3)
    if req.cookies['_rails_lite_app_flash'].nil
      @flash = {}
      @flash[counter] = count
    else
      @flash = JSON.parse(req.cookies['_rails_lite_app_flash'])
      @flash[counter] -= 1
    end
  end

  def display_flash?
    @flash[counter] == 0
  end

  def store_flash(res)
    res.set_cookie(
      '_rails_lite_app_flash',
      { path: '/', value: @flash.to_json }
    )
  end

  private

  def [](key)
    @flash[key]
  end

  def []=(key, val)
    @flash[key] = val
  end

end
