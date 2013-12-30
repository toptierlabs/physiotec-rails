class Language < ActiveRecord::Base
	scope :on_api_license, ->(api_license) { where("api_license_id = ?", api_license.id) }

  belongs_to :api_license
  attr_accessible :description, :locale

  validates :description, :locale, :api_license, :presence => true
  validates :locale, :uniqueness => { :scope => :api_license_id }

  def self.locales_on_api_license(api_license_param)
  	Language.where(api_license_id:api_license_param.id).select(:locale).map{ |v| v.locale.as_sym }
  end
end
