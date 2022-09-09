class LoginsController < ApplicationController
  def new
  end

  def create
    if user = authenticate_with_google
      cookies.signed[:user_id] = user.id
      redirect_to user
    else
      redirect_to new_session_url, alert: 'authentication_failed'
    end
  end

  private
    def authenticate_with_google
      if id_token = flash[:google][:id_token]
        User.find_by google_id: GoogleSignIn::Identity.new(id_token).user_id
      elsif error = flash[:google][:error]
        logger.error "Google authentication error: #{error}"
        nil
      end
    end
end

