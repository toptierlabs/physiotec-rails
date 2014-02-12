# == Schema Information
#
# Table name: user_contexts
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  context_id   :integer
#  context_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class UserContext < ActiveRecord::Base
  belongs_to :user,    inverse_of: :user_contexts
  belongs_to :context, polymorphic: true

  validates :user,     presence: true
  validates :context,  presence: true
  validates :user_id,  uniqueness: { scope: [:context_type, :context_id] }
  
  attr_accessible :user_id,
                  :context_type,
                  :context_id

  before_save    :update_user_maximum_context_cache
  after_destroy  :recalculate_user_maximum_context_cache
  after_destroy  :ensure_user_abilities_are_valid

  private

    def update_user_maximum_context_cache
      self_scope = Scope.find_by_name(self.context_type)
      if self_scope > self.user.maximum_context_cache
        self.user.maximum_context_cache = self_scope
        self.user.save!
      end
    end

    def recalculate_user_maximum_context_cache
      user_contexts = UserContext.where(user_id: self.user_id).pluck(:context_type)
      max_user_context = user_contexts.map!{ |v| Scope.find_by_name(v).id }.max
      self.user.maximum_context_cache = max_user_context || Scope.user_scope
      self.user.save!
    end

    def ensure_user_abilities_are_valid
      corrupted_abilities = UserAbility.where(
                                  "user_id = ? AND scope_id > ?",
                                  self.user_id,
                                  self.user.maximum_context_cache
                            ).includes(ability: :permission)
      corrupted_abilities.each do |v|
        unless v.update_attributes({scope_id: self.user.maximum_context_cache})
          v.destroy
        end
      end     
    end

end
