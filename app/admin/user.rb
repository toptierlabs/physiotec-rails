ActiveAdmin.register User do
  filter :context_type
  filter :context_id
  filter :api_license
  filter :scope_permissions
  filter :clinics
  filter :profiles
  filter :first_name
  filter :last_name
  filter :email
  filter :unconfirmed_email
  filter :reset_password_sent_at
  filter :current_sign_in_at
  filter :last_sign_in_at
  filter :reset_password_sent_at
  filter :current_sign_in_ip
  filter :last_sign_in_ip
  filter :confirmed_at
  filter :confirmation_sent_at
  filter :session_token_created_at
  filter :created_at
  filter :updated_at

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

    column 'User abilities' do |v|      
      v.user_abilities.each do | a |
        ul do
          status_tag(a.action.name, :warning)
          status_tag(a.permission.name, :ok)
          status_tag(a.scope.name, :default)              
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

    f.inputs "User Abilities" do
      f.has_many :user_abilities, :allow_destroy => true, :heading => 'user Abilities', :new_record => true do |a|
        #a.input :permission, as: :select, collection: Permission.all
        a.input :permission
        a.input :action
        a.input :scope
      end
    end
    f.actions
  end

  #custom controller that creates the user with admin roles on the selected api_license
  controller do

    def create
      params[:user].merge!({context_id: params[:user][:api_license_id], context_type: ApiLicense.name})
      params[:user].merge!({profile_ids: [Profile.api_license_administrator_profile.id]})
      super
      @user.apply_profiles
      
    end

  end

end
