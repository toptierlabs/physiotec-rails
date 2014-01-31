class Language < ActiveRecord::Base

	scope :on_api_license, ->(api_license) { where("api_license_id = ? OR api_license_id IS NULL", api_license.id) }

	belongs_to :api_license
	attr_accessible :description, :locale

	validates :description, :locale, presence: true
	validates :locale, :uniqueness => { :scope => :api_license_id }

	def display_name
		self.description
	end

end