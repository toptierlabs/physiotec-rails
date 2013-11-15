module assignable

	belongs_to :user_assigned,  :class_name => "User"

	attr_accesible :user_assigned_id

	validates :owner_id, :presence => :true

end