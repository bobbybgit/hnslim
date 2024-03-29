class ApplicationController < ActionController::Base

    require 'bgg'
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?

    def after_sign_out_path_for(resource_or_scope)
        new_user_session_path
    end

    
    

    def after_sign_in_path_for(resource_or_scope)
        dash_content_path
    end

    protected
    
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :surname, :bgg_username])
        devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :surname, :bgg_username])
    end

end
