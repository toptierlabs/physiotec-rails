# == Schema Information
#
# Table name: exercise_medium_illustrations
#
#  id                 :integer          not null, primary key
#  exercise_medium_id :integer
#  illustration       :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  token              :string(255)
#

class ExerciseMediumIllustration < ActiveRecord::Base

	belongs_to :exercise_medium

	validates :exercise_medium, :illustration, presence: :true

	attr_accessible :exercise_medium_id, :illustration, :token
	mount_uploader  :illustration, ImageUploader


end
