ActiveAdmin.register ApiLicense do

  form do |f|
    f.inputs "User Details" do
      f.input :name      
      f.input :description
    end

    f.actions
  end

end
