# == Schema Information
#
# Table name: permissions
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  model_name       :string(255)
#  minimum_scope_id :integer
#  maximum_scope_id :integer
#

class Permission < ActiveRecord::Base

  attr_accessible :name,
                  :model_name,
                  :minimum_scope_id,
                  :maximum_scope_id
  
  has_many  :abilities,  dependent: :destroy

  validates :name,       uniqueness: true,
                         presence: true
  validates :model_name, uniqueness: true,
                         presence: true,
                         inclusion: {
                          # Must exist an active record model with the given name
                          in: lambda {|v| ActiveRecord::Base.descendants.map{ |v| v.name } }
                        }

  validate :domain_scope_consistency

  def is_translatable?
    model_name.constantize.respond_to? :translation_class
  end

  private

    def domain_scope_consistency
      if Scope.find(minimum_scope_id) > Scope.find(maximum_scope_id)
        self.errors[:maximum_scope] << "must be greater or equal than minimum scope"
        false
      end
    end

end
