class Video < ActiveRecord::Base
  attr_accessible :description, :title, :file
  mount_uploader :file, FileUploader
end
