# == Schema Information
#
# Table name: clinics
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  license_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  api_license_id :integer
#

class Clinic < ActiveRecord::Base

	include Assignable

	before_destroy :confirm_relation_with_exercises

	scope :on_api_license, ->(api_license) { where("api_license_id = ?", api_license.id) }

	belongs_to :license,      inverse_of: :clinics
	belongs_to :api_license

	has_many :exercise_media,      as: :context,
	                          dependent: :destroy

  has_many :user_contexts,  dependent: :destroy,
                            as: :context
  has_many :users,          through: :user_contexts


	has_many :categories,     as: :context                               


	validates :license, associated: { message: "reached maximum clinics" },
											:if => lambda { self.license_id_changed? }

	validates :name,        uniqueness: { scope: :license_id }
	validates :name,        presence: true
	validates :license,     presence: true
	validates :api_license, presence: true

	attr_accessible :name, :license_id

  private

	  def confirm_relation_with_exercises
	    if (self.exercises.size > 0)        
	      self.errors[:base] << "Can't delete a clinic unless it is not associated with any exercise"
	      false
	    end
	  end

end
