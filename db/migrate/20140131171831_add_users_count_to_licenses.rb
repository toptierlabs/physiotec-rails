class AddUsersCountToLicenses < ActiveRecord::Migration
  def up
    add_column :licenses, :users_count, :integer
    License.all.each do |v|
    	v.update_column(:users_count, v.users.size)
    end
  end

  def down
  	remove_column :licenses, :users_count, :integer
  end

end
