# == Schema Information
#
# Table name: exercise_medium_videos
#
#  id                 :integer          not null, primary key
#  exercise_medium_id :integer
#  video              :string(255)
#  token              :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  job_id             :string(255)
#  status             :string(255)
#

class ExerciseMediumVideo < ActiveRecord::Base

	belongs_to :exercise_medium
	validates :video, presence: :true

	attr_accessible :exercise_medium_id, :video, :token,  :job_id, :status
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
