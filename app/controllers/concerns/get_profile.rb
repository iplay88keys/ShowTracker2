module GetProfile
  extend ActiveSupport::Concern

  private

  def has_profile
    if user_signed_in?
        unless current_user.profile 
            redirect_to new_profile_path, alert: 'please make a profile before you continue'
        end
    end
  end
end
