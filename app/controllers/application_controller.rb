class ApplicationController < ActionController::Base
  before_filter :client_info
  protect_from_forgery
  
  protected


  def client_info
    browser = request.env['HTTP_USER_AGENT']
    from = request.env['HTTP_REFERER']
    $my_logger.info("user = #{current_user.email}, time = #{Time.now}, from = #{from}, user_agent = #{browser}\n")
  end
    
  # Overwriting the after confirmation redirect path method
  def after_confirmation_path_for(resource_name, resource)
    edit_user_registration_path
  end
end
