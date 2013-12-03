module AssignableHelper

	#multiple associations with exercises
	#models:

	def self.included(base)
		base.class_eval do
			has_many :permissible_scopes, as: :permissible
			has_many :scopes, :through=>:permissible_scopes

			# The owner must exists as a column in the model's table.
			# Instead of using has_one to specify the owner, we decided to use
			# belongs_to for permformance optimization
			belongs_to :owner, :class_name => "User"

			attr_accessible :owner_id
		end
	end

	#has_many :scopes_set
	#belongs_to :context

	def add_set_of_scopes
	#recieves as parameter an array of scope ids
	end

	def set_of_scopes_datatype
	#returns a hash with the reachable scopes
	end


end
