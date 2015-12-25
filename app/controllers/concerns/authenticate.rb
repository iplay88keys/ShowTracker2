module Authenticate
  extend ActiveSupport::Concern

  private
  def restrict_access
    #api_key = ApiKey.find_by_access_token(params[:access_token])
    #head :unauthorized unless api_key
    authenticate_or_request_with_http_token do |token, options|
      if ApiKey.exists?(access_token: token)
        @current_user = ApiKey.where(Access_token: token).pluck('user_id')
        @token_expires = ApiKey.where(Access_token: token).pluck('expires_at')
        return true
      else
        return false
      end
    end
  end
end
