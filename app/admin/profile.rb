ActiveAdmin.register Profile do

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
