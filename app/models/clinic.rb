class Clinic < ActiveRecord::Base

	include AssignableHelper

	before_destroy :confirm_relation_with_exercises

	scope :on_api_license, ->(api_license) { where("api_license_id = ?", api_license.id) }

	belongs_to :license,    inverse_of: :clinics
	belongs_to :api_license

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

  private

  def confirm_relation_with_exercises
    if (self.exercises.size > 0)        
      self.errors[:base] << "Can't delete a clinic unless it is not associated with any exercise"
      false
    end
  end

end