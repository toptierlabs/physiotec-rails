class AddModelNameToPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :model_name, :string
  end
end
