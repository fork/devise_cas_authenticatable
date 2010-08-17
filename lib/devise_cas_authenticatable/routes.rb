require 'action_dispatch/routing/mapper'

module ActionDispatch::Routing
  class Mapper
    protected
  
    def devise_cas(mapping, controllers)
      # service endpoint for CAS server
      get "/", :to => "#{controllers[:cas_sessions]}#service"

      match mapping.path_names[:sign_in], :to => "#{controllers[:cas_sessions]}#create", :as => :"new_#{mapping.name}_session", :via => "get"
      match mapping.path_names[:sign_in], :to => "#{controllers[:cas_sessions]}#create", :as => :"#{mapping.name}_session", :via => "post"
      match mapping.path_names[:sign_out], :to => "#{controllers[:cas_sessions]}#destroy", :as => :"destroy_#{mapping.name}_session", :via => "get"
      
      #get :new, :path => mapping.path_names[:sign_in], :to => "#{controllers[:cas_sessions]}#create"
      #get :create, :path => mapping.path_names[:sign_in], :as => ""
      #get :destroy, :path => mapping.path_names[:sign_out]
    end
  end
end
