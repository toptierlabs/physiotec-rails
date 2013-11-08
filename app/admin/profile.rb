ActiveAdmin.register Profile do
  menu :parent => "3. Profiles", :label => "Profiles"

    show do |profile|
      attributes_table do
        row :id
        row :name
        row :created_at
        row :updated_at
        row "Permission scopes" do |obj|
          obj.permissions_pretty_list
        end
      end
      active_admin_comments
    end



  index do
    column :name
    column 'Permissions' do |obj|
      obj.permissions_pretty_list
    end

    default_actions
  end

  #customization on new and edit profile pages
  form do |f|
    f.inputs "Details" do
      f.input :name, :label => "Profile Name"
    end
    f.inputs "Profile Scopes" do
      f.has_many :profile_scope_permissions, :allow_destroy => true, :heading => 'Profile Scopes', :new_record => true do |cf|
        cf.input :scope_permission
      end
    end
    f.actions
  end

end
