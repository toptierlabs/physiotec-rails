ActiveAdmin.register ScopePermission do
  #menu :label => "Permissions"
  #navigation_menu :scope_permission
  #customization on new and edit profile pages

  filter :permission
  filter :action
  filter :profiles
  filter :user
  filter :scopes
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs "Permission and Action" do
      f.input :permission    
      f.input :action
    end
    f.inputs "Scopes" do
      f.has_many :scope_permission_group_scopes, :allow_destroy => true, :heading => 'Current Scopes', :new_record => true do |cf|
        cf.input :scope
      end
    end
    f.actions
  end

  index do
    column :id
    column :permission
    column :action

    column 'Scopes' do |obj|
      obj.datatype.each do | ppl |
        status_tag(ppl)
      end
    end

    column :created_at
    column :updated_at
    default_actions
  end
end
