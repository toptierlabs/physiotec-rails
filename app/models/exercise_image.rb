# == Schema Information
#
# Table name: exercise_images
#
#  id          :integer          not null, primary key
#  exercise_id :integer
#  image       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  token       :string(255)
#

class ExerciseImage < ActiveRecord::Base

	belongs_to :exercise
	validates :image, presence: :true

	attr_accessible :exercise_id, :image, :token
	mount_uploader :image, ImageUploader

end
