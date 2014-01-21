class ExerciseImage < ActiveRecord::Base

	belongs_to :exercise
	validates :image, presence: :true

	attr_accessible :exercise_id, :image, :token
	mount_uploader :image, ImageUploader

end
