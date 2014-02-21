ActiveAdmin.register Profile do

  filter :api_license
  filter :scope_permissions
  filter :destination_profiles
  filter :name
  filter :created_at
  filter :updated_at

    show do |profile|
      attributes_table do
        row :id
        row :name

        # column 'Profile abilities' do |v|      
        #   v.profile_abilities.each do | a |
        #     ul do
        #       status_tag(a.action.name, :warning)
        #       status_tag(a.permission.name, :ok)
        #       status_tag(a.scope.name, :default)              
        #     end
        #   end
        # end

        row :created_at
        row :updated_at
      end
    end



  index do
    column :name

    default_actions
  end

  #customization on new and edit profile pages
  form do |f|
    f.inputs "Details" do
      f.input :name, :label => "Profile Name"
      f.input :api_license
    end
    f.inputs "Profile Scopes" do
      f.has_many :profile_abilities, :allow_destroy => true, :heading => 'Profile Abilities', :new_record => true do |a|
        #a.input :permission, as: :select, collection: Permission.all
        a.input :permission
        a.input :action
        a.input :scope
      end
    end
    f.actions
  end

end
