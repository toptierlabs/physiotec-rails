ActiveAdmin.register Scope do
  menu :parent => "1. Scopes", :label => "Scopes"

	filter :scope_group
  filter :name
  filter :created_at
  filter :updated_at

  index do
    column :id
    column :scope_group
    column :name
    column :created_at
    column :updated_at
    default_actions
  end

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
