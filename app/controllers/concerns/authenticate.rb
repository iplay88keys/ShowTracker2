module Authenticate
  extend ActiveSupport::Concern

  def self.getKeyUser(token)
    ApiKey.where(access_token: token.split(" ")[1]).pluck('user_id')
  end

  def self.getKeyExpiration(token)
    ApiKey.where(access_token: token.split(" ")[1]).pluck('expires_at')
  end

  private
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      if ApiKey.exists?(access_token: token)
        return true
      else
        render_unauthorized
      end
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    toRender = []
    render json: toRender, status: 401
  end
end
