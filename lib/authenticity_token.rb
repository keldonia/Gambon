class AuthenticityToken
  attr_reader :token

  def initialize(res)
    @token = SecureRandom.urlsafe_base64(32)
    @cookie = { authenticity_token: @token }
    store_token(res)
  end

  def store_token(res)
    res.set_cookie(
      '_authenticity_token_rails_lite_app',
      { path: '/', value: @cookie_val.to_json }
    )
  end

end
