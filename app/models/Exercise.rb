class Exercise < ActiveRecord::Base
	
  include AssignableHelper

  has_many :assignments, :as => :assignable, dependent: :destroy
  belongs_to :api_license
  belongs_to :owner, :class_name => "User"
  belongs_to :context, :polymorphic=>true

  attr_accessible :owner_id, :description, :title, :api_license_id

  validates :title, :api_license_id, :owner_id, :presence => true
  validates :title, :uniqueness => { :scope => :api_license_id }

end