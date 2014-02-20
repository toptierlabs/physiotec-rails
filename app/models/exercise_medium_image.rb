# == Schema Information
#
# Table name: exercise_medium_images
#
#  id                 :integer          not null, primary key
#  exercise_medium_id :integer
#  image              :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  token              :string(255)
#

class ExerciseMediumImage < ActiveRecord::Base

	belongs_to :exercise_medium
	validates :image, presence: :true

	attr_accessible :exercise_medium_id, :image, :token
	mount_uploader :image, ImageUploader

end
