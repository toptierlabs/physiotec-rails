module AbilityAssignable


  def self.included(base)
  	# Holds :user or :profile

  	base.class_eval do
	  	_owner_class_name = "#{self.name[0..-(Ability.name.length+1)]}".as_sym
	  	_singular_class_name = "#{self.name.underscore}".as_sym
	  	_pluralized_class_name = "#{self.name.underscore.pluralize}".as_sym
	  	_owner_column = "#{self.name[0..-(Ability.name.length+1)]}_id".as_sym
	  	_languages_class_name = "#{self.name}Languages".as_sym

	  	attr_accessor :action_id,
		                :permission_id

	    belongs_to :ability,              inverse_of: _pluralized_class_name
	    belongs_to _owner_class_name,     inverse_of: _pluralized_class_name
	    has_one :permission,              through: :ability

	    has_many   _languages_class_name, inverse_of: _singular_class_name
	    has_many  :languages,             through: _languages_class_name

		  validates _owner_class_name,  presence: true
		  validates :ability,           presence: true
		  validates :scope_id,          presence: true
		  validates :action_id,         presence: true
		  validates :permission_id,     presence: true
		  validates :scope_id,          uniqueness: { scope: [_owner_column, :ability_id] }

		  validate :show_action_greater_or_equal_scope
		  validate :self_scope_less_or_equal_than_users_contexts
		  validate :scope_inside_permission_domain

		  before_validation :ensure_ability_is_present
		  after_find        :load_action_id_and_permission_id

		  attr_accessible :action_id,
		                  :permission_id,
		                  :scope_id,
		                  :language_ids

		  def action
		  	Action.find(self.action_id)
		  end

		  def action=(value)
		  	self.action_id = value.id
		  end

		  def scope
		  	Scope.find(self.scope_id)
		  end

		  def scope=(value)
		  	self.scope_id = value.id
		  end

		  private

		    def scope_inside_permission_domain
		    	unless (permission.minimum_scope_id..permission.maximum_scope_id).cover? self.scope_id
		    		errors[:scope_id] << "not valid for the given permission"
		    	end
		    end

		    def self_scope_less_or_equal_than_users_contexts
		    	if self.class == User && self.scope_id.present?
		    		user_chached_scope = Scope.find_by_id(self.user.maximum_context_cache)
		    		self_scope = Scope.find_by_id(self.scope_id)
		    		if self_scope > user_chached_scope
		    			puts 'is invalid'
		    			errors[:scope_id] << "must be less or equal than the maximum user contexts"
		    		end
		    	end
		    end


		  	def show_action_greater_or_equal_scope
		  		unless Action.find(action_id).is_show?
		  			show_ability = self.class.joins(:ability)
		  			    .where("#{self.class.name[0..-(Ability.name.length+1)]}_id = ? AND " << 
		  			     	     "permission_id = ? AND " <<
		  			           "action_id = ?",
		  			           self.method("#{self.class.name[0..-(Ability.name.length+1)].underscore}").call.id,
		  			           self.permission_id,
		  			           Action.show_action.id).first
		  			if show_ability.present? && Action.find(self.action_id) < Action.find(show_ability.action_id)
		  				errors[:scope_id] << "must be equal or greater than permission show scope"
		  			end
		  		end
		  	end

		  	def ensure_ability_is_present
		  		if permission_id.present? && action_id.present?
		  			if Ability.exists?(action_id: action_id, permission_id: permission_id)
		  				self.ability = Ability.where(action_id: action_id,
		  				                             permission_id: permission_id).first
		  			else
		  				self.ability = Ability.create!(action_id: action_id,
		  				                               permission_id: permission_id)
		  			end  				               
		  		end
		  	end

		  	def load_action_id_and_permission_id
		  		self.action_id = ability.action_id
		  		self.permission_id = ability.permission_id
		  	end
		  
		end
  end
end