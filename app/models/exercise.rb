class Exercise < ActiveRecord::Base
	
  include AssignableHelper
  after_create :link_orphan_images

  scope :on_api_license, ->(api_license) {
          where("api_license_id = ? OR api_license_id IS NULL", api_license.id)
        }

  def by_user_scope(user)
    #get user context
    #get permission for read exercises
    result = case user_scope
    when :api_license
      #return all exercises
      where(api_license_id: [api_license.id, nil])
    when :license
      #return exercises inside user license and its clinics
      where(context_type: License.name,
            context_id: user.context_id) <<
      where(context_type: Clinic.name,
            context_id: license.clinics.pluck(:id))

    when :clinic
      #return exercises inside user clinics
        where(context_type: Clinic.name,
        context_id: user.context_id)
    when :own
      #return only user's exercises
    end
    result
  end

  attr_protected  :owner_id,
                  :api_license_id

  attr_accessible :title,
                  :short_title,
                  :description,
                  :exercise_illustrations,
                  :exercise_images,
                  :context_id,
                  :context_type,
                  :code,
                  :token

  attr_accessible :translations_attributes,
                  :exercise_illustrations_attributes,
                  :exercise_images_attributes

  translates :title, :short_title, :description

  has_many   :assignments, :as => :assignable, dependent: :destroy
  has_many   :exercise_illustrations,          dependent: :destroy
  has_many   :exercise_images,                 dependent: :destroy
  belongs_to :api_license
  belongs_to :owner,                           class_name: "User"
  belongs_to :context,                         polymorphic: true

  accepts_nested_attributes_for :translations,
                                :exercise_illustrations,
                                :exercise_images,
                                allow_destroy: true

  validates :api_license,
            :owner,
            :code,
            :context_type,
            :context_id,       :presence => true
  validates :code,             :uniqueness => { :scope => :api_license_id }
  
  def link_orphan_images
    ExerciseImage.where("exercise_id is null && token=?", self.token).each do |ei|
      ei.exercise = self
      ei.save
    end
    ExerciseIllustration.where("exercise_id is null && token=?",  self.token).each do |ei|
      ei.exercise = self
      ei.save
    end
  end

  def as_json(options={})
    aux = super(options).except(:title, :short_title, :description)
    aux[:translations] = self.translations.as_json(except:[:exercise_id,:created_at,:updated_at])
    aux[:translated_locales] = self.translated_locales
    aux
  end

  class Translation
    validates :title,      :presence => true
    validates :locale,     :uniqueness => {:scope => :exercise_id}
  end

end