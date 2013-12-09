class Exercise < ActiveRecord::Base
  has_many :assignments, :as => :assignable, dependent: :destroy
  belongs_to :owner, :class_name => "User"
  belongs_to :context, :polymorphic=>true
  # clinic, license, ??api_license??

  include AssignableHelper

  attr_accessible :owner_id, :description, :title, :license_id

end