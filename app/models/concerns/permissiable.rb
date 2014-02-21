# PRECONDITIONS:
# ==============
# The model to apply the module must have different contexts,
# through a class named Self.name + Contexts. Also, it must
# be associated with many abilities

module Permissiable

  extend ActiveSupport::Concern

  included do

    has_many :user_contexts,  inverse_of: :user

    has_many :context_api_licenses,   through: :user_contexts,
                                      source:  :context,
                                      source_type: 'ApiLicense'
    has_many :context_licenses,       through: :user_contexts,
                                      source:  :context,
                                      source_type: 'License'
    has_many :context_clinics,        through: :user_contexts,
                                      source:  :context,
                                      source_type: 'Clinic'


    has_many :context_api_licenses,    through: :user_contexts,
                                       source:  :context,
                                       source_type: 'ApiLicense'
    has_many :context_licenses,        through: :user_contexts,
                                       source:  :context,
                                       source_type: 'License'
    has_many :context_clinics,         through: :user_contexts,
                                       source:  :context,
                                       source_type: 'Clinic'


    has_many_through_contexts :exercise_media
    has_many_through_contexts :categories
    has_many_through_contexts :users
    has_many_through_contexts :categories
    has_many_through_contexts :section_data

    # Clinics definition
    has_many :api_clinics, through: :context_api_licenses,
                           source: :clinics

    has_many :license_clinics, through: :context_licenses,
                               source: :clinics

    def clinics
      (api_clinics + license_clinics).uniq
    end

    # License definition
    has_many :licenses_from_api, through: :context_api_licenses,
                                 source: :licenses

    def licenses
      (licenses_from_api + context_licenses).uniq
    end

    # users definition
    has_many :api_users,    through: :context_api_licenses,
                            source: :users

    has_many :license_users, through: :context_licenses,
                             source: :users

    has_many :clinic_users, through: :context_licenses,
                              source: :users

    def users
      (api_users + license_users + clinic_users).uniq
    end


  end

  def contexts
    { 
      api_license_ids: context_api_license_ids,
      license_ids:     context_license_ids,
      clinic_ids:      context_clinic_ids
    }
  end

  def contexts=(value)
    self.context_api_license_ids = value[:api_license_ids] #if value.keys.include? :api_license_ids
    self.context_license_ids = value[:license_ids] #if value.keys.include? :license_ids
    self.context_clinic_ids = value[:clinic_ids] #if value.keys.include? :clinic_ids
  end

  module ClassMethods

    def has_many_through_contexts(value)
      # REFRACTOR: THIS METHOD SHOULD BE IMPROVED, BECAUSE THE IN SQL STATEMENT HAS A LIMIT OF INPUTS
      class_object = value.to_s.singularize.camelize.constantize
      class_object.method_defined?(:context) && define_method(value) do      
        class_object = class_object
        #Get the user contexts with them ids
        if 
          elements = []
          api_ids = []
          license_ids = []
          clinic_ids = []
          if self.context_api_licenses.present?
            api_ids = self.context_api_licenses.pluck(:id)
            elements += class_object.where("context_type = 'ApiLicense' AND context_id IN (?)", api_ids)

            license_ids = License.where("api_license_id IN (?)", api_ids).pluck(:id)
            elements += class_object.where("context_type = 'License' AND context_id IN (?)", license_ids)

            clinic_ids = Clinic.where("license_id IN (?)", license_ids).pluck(:id)
            elements += class_object.where("context_type = 'Clinic' AND context_id IN (?)", clinic_ids)
          end
          if self.context_licenses.present?
            license_ids = self.context_licenses.pluck(:id) - license_ids
            elements += class_object.where("context_type = 'License' AND context_id IN (?)", license_ids)

            clinic_ids = Clinic.where("license_id IN (?)", license_ids).pluck(:id) - clinic_ids
            elements += class_object.where("context_type = 'Clinic' AND context_id IN (?)", clinic_ids)
          end
          if self.context_clinics.present?
            clinic_ids = Clinic.where("license_id IN (?)", license_ids).pluck(:id) - clinic_ids
            elements += class_object.where("context_type = 'Clinic' AND context_id IN (?)", clinic_ids)
          end
          return elements
        end
      end
      unless class_object.method_defined?(:context) && self.respond_to?(value)
        self.send(:has_many, value)
      end
    end
  end

  def can?(action, subject, extra_args = {})
    #sanitize the params
    action = action.to_s.titleize
    scope = extra_args[:scope] || nil
    permission = nil
    if ((subject.class == Symbol) || (subject.class == String))
      subject = subject.parameterize.singularize
      permission = Permission.where(name: subject).first
      subject = nil
    else
      permission = Permission.where(model_name: subject.class.name).first
      return true if permission.blank?
    end

    ability = self.user_abilities
                  .joins(:ability)
                  .where(
                          abilities: { permission_id: permission.id,
                                       action_id: Action.find_by_name(action).id }
                        ).first

    if ability.blank?
      return false
    elsif subject.blank? && scope.blank? #from here to below ability is present
      return true 
    elsif subject.present? && (subject.minimum_scope_for(self) <= ability.scope)
      return true
    elsif scope.present? && (ability.scope >= scope)
      return true
    end
    false
  end




end