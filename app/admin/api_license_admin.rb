ActiveAdmin.register ApiLicenseAdmin do
  
  form do |f|
    f.inputs api_license_admin.api_license.name + " Admin Details" do
      f.input :api_license      
      f.input :email
      f.input :first_name
      f.input :last_name
    end
    f.actions
    #label api_license_admin.api_license.name
    
  end
  
  #belongs_to :api_license
  #navigation_menu :api_license

end