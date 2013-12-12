class Assignment < ActiveRecord::Base
  belongs_to :assignable, :polymorphic => true
  belongs_to :user
  validates :user_id, :uniqueness => {:scope => [:assignable_id, :assignable_type]}

  attr_accessible :user_id

end
