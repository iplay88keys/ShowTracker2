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
    #api_key = ApiKey.find_by_access_token(params[:access_token])
    #head :unauthorized unless api_key
    authenticate_or_request_with_http_token do |token, options|
      puts token
      if ApiKey.exists?(access_token: token)
        return true
      else
        return false
      end
    end
  end
end
