class ApplicationController < ActionController::Base
  # before_filter :prepare_for_mobile
  after_filter :client_info
  protect_from_forgery
  
  protected


  def client_info
    return if current_user.nil? or (params[:controller] == 'devise/sessions')
    browser = request.env['HTTP_USER_AGENT']
    from = request.env['HTTP_REFERER']
    $my_logger.info("user = #{current_user.email}, time = #{Time.now}, from = #{from}, user_agent = #{browser}\n")
  end
    
  # Overwriting the after confirmation redirect path method
  def after_confirmation_path_for(resource_name, resource)
    edit_user_registration_path
  end
  
  private

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS|Chrome/
    end
  end
  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end

end
