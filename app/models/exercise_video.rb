class ExerciseVideo < ActiveRecord::Base

	belongs_to :exercise
	validates :video, presence: :true

	attr_accessible :exercise_id, :video, :token
	mount_uploader :video, VideoUploader

end
