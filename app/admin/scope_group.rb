ActiveAdmin.register ScopeGroup do
  menu :parent => "1. Scopes", :label => "Scope Groups"

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
