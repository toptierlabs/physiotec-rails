module AbilityAssignable

  extend ActiveSupport::Concern

  included do

    extend ActiveHash::Associations::ActiveRecordExtensions

    default_scope eager_load(:ability)

    _owner_class_name = "#{self.name[0..-(Ability.name.length+1)]}".as_sym
    _singular_class_name = "#{self.name.underscore}".as_sym
    _pluralized_class_name = "#{self.name.underscore.pluralize}".as_sym
    _owner_column = "#{self.name[0..-(Ability.name.length+1)]}_id".as_sym
    _languages_class_name = "#{self.name}Languages".as_sym

    attr_writer     :action_id,
                    :permission_id

    belongs_to :ability,              inverse_of: _pluralized_class_name
    belongs_to _owner_class_name,     inverse_of: _pluralized_class_name
    has_one :permission,              through: :ability

    has_many   _languages_class_name, inverse_of: _singular_class_name
    has_many  :languages,             through: _languages_class_name

    belongs_to_active_hash :action
    belongs_to_active_hash :scope


    validate :show_action_greater_or_equal_scope
    validate :self_scope_less_or_equal_than_users_contexts
    validate :scope_inside_permission_domain

    before_validation :ensure_ability_is_present

    validates _owner_class_name,  presence: true
    validates :ability,           presence: true
    validates :scope_id,          presence: true
    validates :action_id,         presence: true
    validates :permission_id,     presence: true
    validates :scope_id,          uniqueness: { scope: [_owner_column, :ability_id] }

    attr_accessible :action_id,
                    :permission_id,
                    :scope_id,
                    :language_ids,
                    :ability_id

    def action_id
      @action_id ||= self.ability.action_id
    end
    
    def permission_id
      @permission_id ||= self.ability.permission_id
    end

  end


  private

    def scope_inside_permission_domain
      unless (permission.minimum_scope..permission.maximum_scope).cover? self.scope
        errors[:scope_id] << "not valid for the given permission"
      end
    end

    def self_scope_less_or_equal_than_users_contexts
      if self.respond_to? :user
        if self.scope > self.user.maximum_context_cache
          puts 'is invalid'
          errors[:scope_id] << "must be less or equal than the maximum user contexts"
        end
      end
    end


    def show_action_greater_or_equal_scope
      unless action.is_show?
        show_ability = self.class.joins(:ability)
        .where("#{self.class.name[0..-(Ability.name.length+1)]}_id = ? AND " << 
          "permission_id = ? AND " <<
          "action_id = ?",
          self.method("#{self.class.name[0..-(Ability.name.length+1)].underscore}").call.id,
          self.permission_id,
          Action.show_action.id).first
        if show_ability.present? && (self.scope > show_ability.scope)
          errors[:scope_id] << "must be equal or greater than permission show scope"
        end
      end
    end

    def ensure_ability_is_present
      if Ability.exists?(action_id: action_id, permission_id: permission_id)
        self.ability = Ability.where(action_id: action_id,
          permission_id: permission_id).first
      else
        self.ability = Ability.create!(action_id: action_id,
          permission_id: permission_id)
      end                        
    end

end