module AbilityAssignable
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
  extend ActiveSupport::Concern

  included do

    extend ActiveHash::Associations::ActiveRecordExtensions

    default_scope joins(:ability)

    _owner_class_name = "#{self.name[0..-(Ability.name.length+1)]}".as_sym
    _singular_class_name = "#{self.name.underscore}".as_sym
    _pluralized_class_name = "#{self.name.underscore.pluralize}".as_sym
    _owner_column = "#{self.name[0..-(Ability.name.length+1)]}_id".as_sym

    attr_writer     :action_id,
                    :permission_id,
                    :scope_id

    belongs_to :ability,              inverse_of: _pluralized_class_name
    belongs_to :permission
    belongs_to _owner_class_name,     inverse_of: _pluralized_class_name

    belongs_to_active_hash :action
    belongs_to_active_hash :scope

    #validate :show_action_greater_or_equal_scope
    #validate :scope_inside_permission_domain

    before_validation :ensure_ability_is_present

    validates _owner_class_name,  presence: true
    validates :ability,           presence: true

    validates :scope_id,          presence: true
    validates :action_id,         presence: true
    validates :permission_id,     presence: true
    validates :ability_id,        uniqueness: { scope: _owner_column }

    attr_accessible :action_id,
                    :permission_id,
                    :scope_id,
                    :ability_id

    def action_id
      @action_id ||= ability.present? ? self.ability.action_id : nil
    end
    
    def permission_id
      @permission_id ||= ability.present? ? self.ability.permission_id : nil
    end

    def permission
      if @permission.present? && @permission.id == @permission_id
        @permission
      else
        @permission = Permission.find_by_id(permission_id)
      end
    end

    def permission=(value)
      permission_id = value.id
      @permission = value
    end

    def scope_id
      @scope_id ||= ability.present? ? self.ability.scope_id : nil
    end

  end


  private

    def scope_inside_permission_domain
      unless (permission.minimum_scope..permission.maximum_scope).cover? self.scope
        errors[:scope_id] << "not valid for the given permission"
        puts "not valid for the given permission"
      end
    end

    def show_action_greater_or_equal_scope
      unless action.is_show?
        show_ability = self.class.where(
          "#{self.class.name[0..-(Ability.name.length+1)]}_id = ? AND " << 
          "permission_id = ? AND " <<
          "action_id = ?",
          self.method("#{self.class.name[0..-(Ability.name.length+1)].underscore}").call.id,
          self.permission_id,
          Action.show_action.id).first
        if show_ability.present? && (self.scope > show_ability.scope)
          errors[:scope_id] << "must be equal or greater than permission show scope"
          puts "must be equal or greater than permission show scope"
        end
      end
    end

    def ensure_ability_is_present
      if Ability.exists?(action_id: action_id, permission_id: permission_id, scope_id: scope_id)
        self.ability = Ability.where(
                                      action_id: action_id,
                                      permission_id: permission_id,
                                      scope_id: scope_id
                                    ).first
      else
        self.ability = Ability.create!  action_id: action_id,
                                        permission_id: permission_id,
                                        scope_id: scope_id
      end                        
    end

end