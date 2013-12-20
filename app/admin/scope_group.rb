ActiveAdmin.register ScopeGroup do
  menu :parent => "1. Scopes", :label => "Scope Groups"

	filter :api_license
  filter :scopes
  filter :name
  filter :description
  filter :created_at
  filter :updated_at

  controller do
	  def destroy
	    destroy! do |success, failure|
	      failure.html do
	      	flash.clear
	        flash[:error] = "The deletion failed because: " + resource.errors.full_messages.to_sentence
	        render action: :index
	      end
	    end
	  end
  end

end
