class UserContext < ActiveRecord::Base
  belongs_to :user
  belongs_to :context, polymorphic: true

  validates :user,     presence: true
  validates :context,  presence: true
  validates :user_id,  uniqueness: { scope: [:context_type, :context_id] }
  
  attr_accessible :user_id,
                  :context_type,
                  :context_id
end
