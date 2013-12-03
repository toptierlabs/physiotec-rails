module PermissionsHelper
	class ForbiddenAccess < StandardError

		def initialize
		end

	end

	module PermissibleHelper

		#has_many :scopes_set
		#belongs_to :context

		def add_set_of_scopes
		end

		def set_of_scopes_datatype
		end

	end

end
