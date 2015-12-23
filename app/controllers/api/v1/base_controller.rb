module Api
  module V1
    class BaseController < ApplicationController
      private
      def current_user
        @current_user ||= User.find(doorkeeper_token.resource_owner_id)
      end
    end
  end
end
