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

  extend ActiveHash::Associations::ActiveRecordExtensions

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

  belongs_to_active_hash :minimum_scope,
                         class_name: "Scope",
                         foreign_key: "minimum_scope_id"

  belongs_to_active_hash :maximum_scope,
                         class_name: "Scope",
                         foreign_key: "maximum_scope_id"


  validate :domain_scope_consistency

  def is_translatable?
    model_name.constantize.respond_to? :translation_class
  end

  def is_assignable?
    classes = model_name.underscore.split("_")
    classes.each do |v|
      return false unless Object.const_defined?(v.camelize)
      return false unless model_name.constantize.new.respond_to? v.to_sym

    end
    true
  end

  def model_class
    self.model_name.constantize
  end

  private

    def domain_scope_consistency
      if minimum_scope > maximum_scope
        self.errors[:maximum_scope_id] << "must be greater or equal than minimum scope"
        false
      end
    end

end
