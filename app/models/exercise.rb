class Exercise < ActiveRecord::Base
	
  include AssignableHelper
  after_create :link_orphan_media

  scope :on_api_license, ->(api_license) {
          where("api_license_id = ? OR api_license_id IS NULL", api_license.id)
        }

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

  translates    :title, :short_title, :description
  default_scope includes(:translations)

  has_many   :assignments, :as => :assignable, dependent: :destroy
  has_many   :exercise_illustrations,          dependent: :destroy
  has_many   :exercise_images,                 dependent: :destroy
  has_many   :exercise_videos,                 dependent: :destroy
  has_many   :subsection_exercises
  has_many   :subsections,                     through: :subsection_exercises
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
  
  def link_orphan_media
    ExerciseImage.where("exercise_id is null && token=?", self.token).each do |ei|
      ei.exercise = self
      ei.save
    end
    ExerciseIllustration.where("exercise_id is null && token=?",  self.token).each do |ei|
      ei.exercise = self
      ei.save
    end
    ExerciseVideo.where("exercise_id is null && token=?",  self.token).each do |ei|
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