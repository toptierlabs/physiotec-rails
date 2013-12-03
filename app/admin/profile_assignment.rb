ActiveAdmin.register ProfileAssignment do
  menu :parent => "Profiles"
  index do
  	column :id
    column :profile
    column :destination_profile
    default_actions
    end

end
