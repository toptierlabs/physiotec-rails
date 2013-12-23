class Exercise < ActiveRecord::Base
	
  include AssignableHelper

  has_many :assignments, :as => :assignable, dependent: :destroy
  has_many :exercise_illustrations, dependent: :destroy
  has_many :exercise_images, dependent: :destroy
  belongs_to :api_license
  belongs_to :owner, :class_name => "User"
  belongs_to :context, :polymorphic=>true

  attr_accessible :title, :short_title, :description
  attr_protected :owner, :api_license_id, :code


  validates :title, :short_title, :api_license, :owner, :code, :presence => true
  validates :title, :uniqueness => { :scope => :api_license_id }
  validates :code, :uniqueness => { :scope => :api_license_id }


end