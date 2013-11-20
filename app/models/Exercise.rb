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
  		list_scopes <<  :own << :clinic << :license << :api_license
  	#user belongs to the same clilic
  	elsif (self.context.respond_to?(:clinic)) && (user.clinics.include? self.context.clinic)
  		list_scopes << :clinic << :license << :api_license
  	#user belongs to the same license
  	elsif self.context.respond_to?(:license) && self.context.license == user.license
  		list_scopes << :license << :api_license
    elsif self.context.respond_to?(:api_license) && self.context.api_license == user.api_license
      list_scopes << :api_license
    end
    list_scopes
    # elsif self.context.instance_of? Clinic && user.clinics.include? self.context
    #   list_scopes << :clinic << :license
  end

end