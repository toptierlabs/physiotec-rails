class Video < ActiveRecord::Base
  validates :job_id, :uniqueness => true
  attr_accessible :description, :title, :file, :job_id, :status
  mount_uploader :file, FileUploader

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
