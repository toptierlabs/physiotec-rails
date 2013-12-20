ActiveAdmin.register User do
  menu :label => "API License Administrators"
  index do
    column :email
    column :api_license
    #column :name
    column 'Profiles' do |obj|
      ul do
        obj.profiles.each do | p |
          status_tag(p.name, :ok)              
        end
      end
    end
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

    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count

    default_actions
  end

  #customization on new and edit profile pages
  form do |f|
    f.inputs "User Details" do
      f.input :api_license      
      f.input :email
      f.input :first_name
      f.input :last_name
    end

    f.inputs "Profiles" do
      f.has_many :user_profiles, :allow_destroy => true, :heading => 'Current Profiles', :new_record => true do |cf|
        cf.input :profile
      end
    end

    f.inputs "Permissions" do
      f.has_many :user_scope_permissions, :allow_destroy => true, :heading => 'Permissions', :new_record => true do |cf|
        cf.input :scope_permission
      end
    end

    f.actions
  end

  #custom controller that creates the user with admin roles on the selected api_license
  controller do

    def create
      params[:user].merge!({context_id: params[:user][:api_license_id], context_type: ApiLicense.class.name})
      params[:user].merge!({profile_ids: [Profile.api_license_administrator_profile.id]})
      super
    end

  end

end
