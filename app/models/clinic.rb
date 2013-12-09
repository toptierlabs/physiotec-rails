class Clinic < ActiveRecord::Base

	include AssignableHelper

	belongs_to :license

	#multiple associations with exercises
	has_many :exercises, as: :context

	has_many :users, as: :context

	validates :name, :uniqueness => {:scope => :license_id}
	validates :name, :presence => true

	attr_accessible :name, :license_id
	

	def clinic
		self
	end

	def api_license
		self.license.api_license
	end

end