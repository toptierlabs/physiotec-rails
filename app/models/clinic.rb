class Clinic < ActiveRecord::Base

	include AssignableHelper

	belongs_to :license
	attr_accessible :name, :license_id

	#multiple associations with exercises
	has_many :exercises, as: :context

	has_many :users, as: :context

	def clinic
	self
	end

end