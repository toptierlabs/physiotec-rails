ActiveAdmin.register User do
  form do |f|
    f.inputs "User Details" do
      f.input :api_license      
      f.input :email
      f.input :first_name
      f.input :last_name
    end
    f.actions
    #label api_license_admin.api_license.name
    
  end

  #custom controller that creates the user with admin roles on the selected api_license
  controller do
     def create
      super do |format|
        user_profile = UserProfile.create(user: @user,
                                   profile: Profile.license_administrator_profile)
      end
    end
  end

end

  #belongs_to :api_license
  #navigation_menu :api_license
