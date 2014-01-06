class Clinic < ActiveRecord::Base

	include AssignableHelper

	scope :on_api_license, ->(api_license) { where("api_license_id = ?", api_license.id) }

	belongs_to :license
	belongs_to :api_license
	#multiple associations with exercises
	has_many :exercises, as: :context, :dependent => :destroy
	has_many :users, as: :context, :dependent => :destroy


	validates :license, :associated => { :message => "reached maximum clinics" },
											:if => lambda { self.license_id_changed? }

	validates :name, :uniqueness => {:scope => :license_id}
	validates :name, :license, :api_license, :presence => true

	attr_accessible :name, :license_id	 
	attr_protected :api_license_id

	def clinic
		self
	end
	

	def context
		self.license
	end

  #returns object class name, required for returning user's context
  def entity
    self.class.name
  end

end