  # create_table "categories", :force => true do |t|
  #   t.integer  "owner_id"
  #   t.integer  "context_id",   :null => false
  #   t.string   "context_type", :null => false
  #   t.datetime "created_at",   :null => false
  #   t.datetime "updated_at",   :null => false
  # end

class Category < ActiveRecord::Base

  include AssignableHelper

	belongs_to :owner,                           class_name: "User"
  belongs_to :context,                         polymorphic: true
  belongs_to :api_license

  has_many   :sections,     inverse_of: :category
  has_many   :section_data, through: :sections

  attr_accessible :name,
                  :context_type,
                  :context_id,
                  :section_datum_ids,
                  :translations_attributes,
                  :sections_attributes

  translates :name
  
  validates :name,            uniqueness: { scope: [:context_type, :context_id] },
                              presence: true
  validates :context_type,    presence: true
  validates :context_id,      presence: true
  validates :owner_id,        presence: true

  accepts_nested_attributes_for :translations,    allow_destroy: true
  accepts_nested_attributes_for :sections,    allow_destroy: true

  def self.by_user(user)
    #get user context
    #get permission for read exercises
    user_scope = :api_license
    result = case user_scope
    when :api_license
      #return all exercises

      where api_license_id: [user.api_license.id, nil]
    when :license
      #return exercises inside user license and its clinics

      licenses = user.contexts(only: :license)
                     .map(&:id)
      clinics = user.contexts(only: :clinic)
                    .map(&:id)
      where(
            api_license_id: [user.api_license.id, nil],
            context_type:   License.name,
            context_id:     licenses,
            context_type:   Clinic.name,
            context_id:     clinics
          )

    when :clinic
      #return exercises inside user clinics

      clinics = user.contexts(only: :clinic)
                    .map(&:id)

      where api_license_id: [user.api_license.id, nil],
            context_type:   Clinic.name,
            context_id:     clinics
    when :own
      #return only user's exercises

      where owner_id: user.id
    end
    result
  end


end
