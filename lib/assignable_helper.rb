module AssignableHelper

	#multiple associations with exercises
	#models:

	def self.included(base)
		base.class_eval do
			has_many :permissible_scopes, as: :permissible
			has_many :scopes, :through=>:permissible_scopes

			# The owner must exists as a column in the model's table.
			# Instead of using has_one and an auxiliary table to specify the owner
			# we decided to use belongs_to for permformance optimization (less selects)
			belongs_to :owner, :class_name => "User"

			attr_accessible :owner_id

		end
	end

	def add_scope
	#recieves as a parameter an array of scope ids
	end

	def approves_verification(scopes)
	#recieves an array of scopes and returns true if

	#select scopes and scope groups associated with this model
	#create array with the scope groups of the given parameters
	#!!!!!!////----//// remove clinic scope group from the created array
	#!!!!!!////----//// check the Clinic scope of the permission and the context of the object match

	#check if the arrays are equal
	#compare arrays and if they match
	end

end