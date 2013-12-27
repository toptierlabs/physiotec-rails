class ExerciseIllustration < ActiveRecord::Base

	belongs_to :exercise

	validates :exercise, :illustration, presence: :true

	attr_accessible :exercise_id, :illustration
	mount_uploader :illustration, ImageUploader


end
