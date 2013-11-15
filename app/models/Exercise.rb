class Exercise < ActiveRecord::Base
  has_many :assignments, :as => :assignable, dependent: :destroy
  belongs_to :owner, :class_name => "User"
  belongs_to :context, :polymorphic=>true
  # clinic, license, ??api_license??


  attr_accessible :owner_id, :description, :title, :license_id

	def scopes(user)
  	list_scopes = []
		#user is owner
  	if self.owner == user
  		list_scopes <<  :own << :clinic << :license
  	#user belongs to the same clilic
  	elsif self.context.method_defined?(:clinic) && user.method_defined?(:clinic) && self.context.clinic == user.clinic
  		list_scopes << :clinic << :license
  	#user belongs to the same license
  	elsif self.context.method_defined?(:license) && user.method_defined?(:license) && self.context.license == user.license
  		list_scopes << :license
  	end
  end

end