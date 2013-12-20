ActiveAdmin.register User do
  menu :label => "API License Administrators"
  index do
    column :email
    column :api_license
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

    f.actions
  end

  #custom controller that creates the user with admin roles on the selected api_license
  controller do

    def create
      params[:user].merge!({context_id: params[:user][:api_license_id], context_type: ApiLicense.name})
      params[:user].merge!({profile_ids: [Profile.api_license_administrator_profile.id]})
      super do |format|
        puts '*'*80
        puts @user.errors.to_json
      end
    end

  end

end
