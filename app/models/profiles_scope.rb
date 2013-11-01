class ProfilesScope < ActiveRecord::Base
  belongs_to :profile
  belongs_to :scope

  attr_accessible :profile_id, :scope_id
end
