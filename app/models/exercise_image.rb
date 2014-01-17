class ExerciseImage < ActiveRecord::Base

	belongs_to :exercise
	validates :image, presence: :true

	attr_accessible :exercise_id, :image
	mount_uploader :image, ImageUploader

end
