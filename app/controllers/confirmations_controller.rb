class ConfirmationsController < Devise::ConfirmationsController
  layout "confirmation"

  def show
    self.resource = resource_class.find_by_unhashed_confirmation_token(params[:confirmation_token]) if params[:confirmation_token].present?
    #super if resource.nil? or resource.confirmed?
    redirect_to COMMON_OPTIONS['physiotec-common-url'] if resource.id.nil? or resource.confirmed?
  end

  def confirm

    self.resource = resource_class.find_by_confirmation_token(params[resource_name][:confirmation_token]) if params[resource_name][:confirmation_token].present?
    
    self.resource.password = params[resource_name][:password]
    self.resource.password_confirmation = params[resource_name][:password_confirmation]
    self.resource.first_name = params[resource_name][:first_name]
    self.resource.last_name = params[resource_name][:last_name]

    if resource.password_match? && resource.save && self.resource.confirm!

      # self.resource.confirm!
      # self.resource = resource_class.confirm_by_token(params[resource_name][:confirmation_token])
      set_flash_message :notice, :confirmed
      #sign_in_and_redirect(resource_name, resource)
      if self.resource.api_administrator?
        redirect_to COMMON_OPTIONS['physiotec-api-administrator-url']
      else
        redirect_to COMMON_OPTIONS['physiotec-common-url']
      end
    else
      render :action => "show"
    end
  end
end
