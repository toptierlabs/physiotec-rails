module ownable

	belongs_to :owner, :class_name => "User"

	attr_accesible :owner_id

	validates :owner_id, :presence => :true

	def has_permission?(user)
		#license de usuario
		#ver si licencia de usuario es igual a self.license
		#si es igual y usuario es owner, devolver :own, :license, :clinic
		#si es igual y usuario no es owner, devolver :license, :clinic??
		#si son distintos devolver nada
		if user.license_id != self.license_id
			#TODO error description
			break
			

	end

end