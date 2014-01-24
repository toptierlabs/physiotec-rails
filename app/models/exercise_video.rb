class ExerciseVideo < ActiveRecord::Base

	belongs_to :exercise
	validates :video, presence: :true

	attr_accessible :exercise_id, :video, :token,  :job_id, :status
	mount_uploader :video, VideoUploader

 
  STATES={:completed=> "COMPLETED", :failed=> "FAILED", :converting=> "CONVERTING"}

 
  def is_completed?
          self.state = STATES[:completed]
  end

  def is_failed?
          self.state = STATES[:failed]
  end

  def is_converting?
          self.state = STATES[:converting]
  end

end
