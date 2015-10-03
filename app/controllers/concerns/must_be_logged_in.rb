module MustBeLoggedIn
  extend ActiveSupport::Concern

  private

  def prevent_access
    unless user_signed_in?
        redirect_to user_session_path, alert: 'You must be logged in'
    end
  end
end
