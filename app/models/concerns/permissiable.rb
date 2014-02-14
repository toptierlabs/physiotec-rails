module Permissiable

  extend ActiveSupport::Concern

  included do

    has_many :user_contexts,  inverse_of: :user

    has_many :contexts,       through: :user_contexts

    has_many :context_api_licenses,   through: :user_contexts,
                                      source:  :context,
                                      source_type: 'ApiLicense'
    has_many :context_licenses,       through: :user_contexts,
                                       source:  :context,
                                       source_type: 'License'
    has_many :context_clinics,        through: :user_contexts,
                                       source:  :context,
                                       source_type: 'Clinic'

    has_many :users,          through: :contexts

    has_many_through_contexts :exercises
    #has_many_through_contexts :clinics
    has_many_through_contexts :categories

  end

  def context_ids
    { 
      api_license_ids: api_license_ids,
      license_ids:     license_ids,
      clinic_ids:      clinic_ids
    }
  end

  module ClassMethods

    def has_many_through_contexts(value)
      define_method(value) do      
        class_object = value.to_s.singularize.camelize.constantize
        #Get the user contexts with them ids
        if class_object.method_defined? :context
          if self.context_api_licenses.present?
            return class_object.where("api_license_id IN (?)", self.context_api_licenses.pluck(:id))
          end
          elements = []
          license_ids = []
          clinic_ids = []
          if self.context_licenses.present?
            license_ids = self.context_licenses.pluck(:id)
            elements << class_object.where("context_type = 'License' AND context_id IN (?)", license_ids)
            clinic_ids = Clinic.where("license_id IN (?)", license_ids).pluck(:id)
            elements << class_object.where("context_type = 'Clinic' AND context_id IN (?)", clinic_ids)
          end
          if self.context_clinics.present?
            # Append to elements only the context_clinics that are not the user context_licenses
            clinic_ids = clinic_ids - self.context_clinics.all.map(&:id)
            elements << class_object.where("context_type = 'Clinic' AND context_id IN (?)", clinic_ids)
          end
          elements          
        end
      end

    end

  end

  def can?(action, subject, extra_args = {})
    #sanitize the params
    action = action.to_s.titleize
    scope = extra_args[:scope] || nil
    permission = nil
    if ((subject.class == Symbol) || (subject.class == String))
      permission = Permission.where(name: subject).first
      subject = nil
    else
      permission = Permission.where(model_name: subject.class.name).first
    end

    ability = self.user_abilities
                  .joins(:ability)
                  .where(abilities: { permission_id: permission.id,
                                      action_id: Action.find_by_name(action).id }
                        ).first

    if ability.blank?
      return false
    elsif subject.blank? && scope.blank? #from here to below ability is present
      return true 
    elsif subject.present? && (subject.minimum_scope_for(self) <= Scope.find(ability.scope_id))
      return true
    elsif scope.present? && (ability.scope >= scope)
      return true
    end
    false
  end




end