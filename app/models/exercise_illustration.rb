# == Schema Information
#
# Table name: exercise_illustrations
#
#  id           :integer          not null, primary key
#  exercise_id  :integer
#  illustration :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  token        :string(255)
#

class ExerciseIllustration < ActiveRecord::Base

	belongs_to :exercise

	validates :exercise, :illustration, presence: :true

	attr_accessible :exercise_id, :illustration, :token
	mount_uploader  :illustration, ImageUploader


end
