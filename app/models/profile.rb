# == Schema Information
#
# Table name: profiles
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  api_license_id :integer
#

class Profile < ActiveRecord::Base

  before_destroy :check_protection

  scope :on_api_license, ->(api_license) { where("api_license_id = ? OR api_license_id IS NULL", api_license.id) }

  attr_accessible :name,
                  :profile_assignment,
                  :profile_assignment_attributes,
                  :destination_profiles_attributes,
                  :source_profiles,
                  :destination_profiles,
                  :api_license_id

  belongs_to :api_license

  has_many :profile_abilities, :dependent => :destroy
  has_many :abilities, :through => :profile_abilities

  # a profile may have multiple profiles, this relation is used when a
  # new user is created, or a user wants to assign to another user a profile
  has_many :profile_assignment, :dependent => :destroy
  has_many :destination_profiles, :through => :profile_assignment

  validates :name, presence: true
  validates :name, uniqueness: { scope: :api_license_id }

  accepts_nested_attributes_for :profile_assignment, :allow_destroy => true
  accepts_nested_attributes_for :profile_abilities,  :allow_destroy => true

  def permissions_pretty_list
  	ppl = []
  	self.profile_scope_permissions.each do |psp|
  		ppl <<  psp.datatype
  	end
  	ppl
  end

  def self.license_administrator_profile
    self.find_by_name("License administrator")
  end

  def assignable_profiles
    res = []
    self.destination_profiles.each do | v |
      res << v
    end
    res.uniq
  end

  def self.api_license_administrator_profile
    self.find_by_name("API Administrator")
  end

  private

    def check_protection
      if self.protected?
        self.errors[:base] << "Profile protected against deletion"
        false
      end
    end

end
