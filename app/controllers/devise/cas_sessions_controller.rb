class Devise::CasSessionsController < Devise::SessionsController  
  def service
    if signed_in?(resource_name)
      redirect_to after_sign_in_path_for(resource_name)
    else
      redirect_to root_url
    end
  end
  
  def create
    resource = authenticate(resource_name)
    if resource
      sign_in_and_redirect(resource)
    elsif warden.result == :redirect
      throw :warden, :scope => resource_name
    else
      throw InvalidCasTicketException.new(params[:ticket])
    end
  end
      
  def destroy
    sign_out(resource_name)
    destination = request.protocol
    destination << request.host
    destination << ":#{request.port.to_s}" unless request.port == 80
    destination << after_sign_out_path_for(resource_name)
    redirect_to(::Devise.cas_client.logout_url(destination))
  end
end
