class AddStatusAndJobIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :status, :string
    add_column :videos, :job_id, :string
  end
end
