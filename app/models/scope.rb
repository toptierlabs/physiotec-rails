class Scope < ActiveRecord::Base
  belongs_to :permission
  attr_accessible :permission_id, :name

  def display_name
  	self.permission.name + ' (' + self.name + ')'
  end
end
