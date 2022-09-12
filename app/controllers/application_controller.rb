class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?
  #before_action :doorkeeper_authorize!
  #skip_before_action :verify_authenticity_token

      protected

      def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:password, :email, :first_name, :last_name, :phone, :twitter, :password_confirmation)}
          devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:password, :email, :first_name, :last_name, :phone, :twitter, :password_confirmation)}
          devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:password, :email, :first_name, :last_name, :phone, :twitter, :password_confirmation, :current_password)}
      end

      private

    # helper method to access the current user from the token
    # def current_user
    #   @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id])
    # end
end
