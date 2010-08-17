module Devise
  module Models
    module CasAuthenticatable
      extend ActiveSupport::Concern
      
      module ClassMethods
        def authenticate_with_cas_ticket(ticket)
          ::Devise.cas_client.validate_service_ticket(ticket) unless ticket.has_been_validated?
          
          if ticket.is_valid?
            logger.debug "Ticket is valid and is for user #{ticket.response.user}"
            conditions = {:username => ticket.response.user}
            puts conditions.inspect
            
            resource = find_for_authentication(conditions)
            resource = new(conditions) if (resource.nil? and ::Devise.cas_create_user)
            return nil unless resource
            
            if resource.new_record?
              logger.debug "Creating new user record"
              if resource.respond_to? :cas_extra_attributes=
                resource.cas_extra_attributes = ticket.response.extra_attributes
              end
              
              #create(conditions)
							# fix extra attributes not beeing set on first login
							resource.save
							resource
            else
              if resource.respond_to? :cas_extra_attributes=
                logger.debug "Updating existing user record"
                resource.cas_extra_attributes = ticket.response.extra_attributes
                resource.save
              end
              
              resource
            end
          else
            logger.debug "Ticket is invalid"
            return nil
          end
        end
      end
    end
  end
end
