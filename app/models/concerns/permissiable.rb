module Permissiable

  extend ActiveSupport::Concern

  included do

    has_many :user_contexts,  inverse_of: :user

    has_many :api_licenses,   through: :user_contexts,
                              source:  :context,
                              source_type: 'ApiLicense'
    has_many :licenses,       through: :user_contexts,
                              source:  :context,
                              source_type: 'License'
    has_many :clinics,        through: :user_contexts,
                              source:  :context,
                              source_type: 'Clinic'

  end

  def contexts
    { 
      api_license_ids: api_license_ids,
      license_ids:     license_ids,
      clinic_ids:      clinic_ids
    }
  end

  def contexts=(value)
      self.api_license_ids = value[:api_license_ids] if value.has_key? :api_license_ids
      self.license_ids = value[:license_ids] if value.has_key? :license_ids
      self.clinic_ids = value[:clinic_ids] if value.has_key? :clinic_ids
  end


  def can?(action, subject, extra_args = {})
    #sanitize the params
    action = action.to_s
    scope = extra_args[:scope] || nil
    locales = Language.where(locale: extra_args[:locales]).pluck(:id) || []
    return false if extra_args[:locales].present? && (locales.size != extra_args[:locales].size)
    permission = nil
    if ((subject.class == Symbol) || (subject.class == String))
      permission = Permission.where(name: subject).first
      subject = nil
    else
      permission = Permission.where(model_name: subject.class.name).first
    end

    abilities = self.user_abilities
                  .joins(:ability)
                  .where(abilities: { permission_id: permission.id,
                                      action_id: Action.find_by_name(action).id })

    return false unless abilities.present?
    return true if subject.blank? && scope.blank? && locales.blank?
    result = true
    abilities.each do |v|
      if subject.present?
        result = (subject.minimum_scope_for(self) <= Scope.find(v.scope_id))
      elsif scope.present?
        result = v.scope >= scope
      end
      if locales.present?
        result &&= (locales - v.languages.pluck(:id)).empty? if locales.present? && permission.is_translatable?
      end
      return true if result
    end
    false
  end

end