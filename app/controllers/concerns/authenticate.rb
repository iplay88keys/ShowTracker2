module Authenticate
  extend ActiveSupport::Concern

  def self.getKeyUser(token)
    ApiKey.where(access_token: token.split(" ")[2]).pluck('user_id')
  end

  def self.getKeyExpiration(token)
    ApiKey.where(access_token: token.split(" ")[2]).pluck('expires_at')
  end

  private
  def restrict_access
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_or_request_with_http_token do |token, options|
      ApiKey.exists?(access_token: token)
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: 'Bad credentials', status: 401
  end
end
