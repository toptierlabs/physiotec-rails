# == Schema Information
#
# Table name: user_abilities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  ability_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserAbility < ActiveRecord::Base

  require 'concerns/ability_assignable'
	include AbilityAssignable
	
  before_validation :ensure_self_scope_is_less_or_equal_than_users_contexts
  validate :self_scope_less_or_equal_than_users_contexts

  private

    def ensure_self_scope_is_less_or_equal_than_users_contexts
      if (permission.minimum_scope..permission.maximum_scope).cover?(self.scope)
        self.scope = [self.user.maximum_context_cache, self.scope].min 
      end
    end

    def self_scope_less_or_equal_than_users_contexts
      if self.respond_to? :user
        if self.scope > self.user.maximum_context_cache
          errors[:scope_id] << "must be less or equal than the maximum user contexts"
        end
      end
    end

end
