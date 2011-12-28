class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected

  # Overwriting the after confirmation redirect path method
  def after_confirmation_path_for(resource_name, resource)
    edit_user_registration_path
  end
end
