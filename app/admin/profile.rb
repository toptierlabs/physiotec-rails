ActiveAdmin.register Profile do

  filter :api_license
  filter :destination_profiles
  filter :name
  filter :created_at
  filter :updated_at

    show do |profile|
      attributes_table do
        row :id
        row :name
        row :created_at
        row :updated_at
        row "Permission scopes" do |obj|
          ul do
            obj.permissions_pretty_list.each do | ppl |
              li do
                status_tag(ppl[:action], :warning)
                status_tag(ppl[:permission], :ok)
                ppl[:scopes].each do | scope |
                  status_tag(scope)
                end
              end
            end
          end
        end
      end
    end



  index do
    column :name
    column 'Permissions' do |obj|
      ul do
        obj.permissions_pretty_list.each do | ppl |
          li do
            status_tag(ppl[:action], :warning)
            status_tag(ppl[:permission], :ok)
            ppl[:scopes].each do | scope |
              status_tag(scope)
            end
          end
        end
      end
    end

    default_actions
  end

  #customization on new and edit profile pages
  form do |f|
    f.inputs "Details" do
      f.input :name, :label => "Profile Name"
      f.input :api_license
    end
    f.inputs "Profile Scopes" do
      f.has_many :profile_scope_permissions, :allow_destroy => true, :heading => 'Profile Scopes', :new_record => true do |cf|
        cf.input :scope_permission
      end
    end
    f.actions
  end

end
