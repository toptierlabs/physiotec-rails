class Exercise < ActiveRecord::Base
	
  include AssignableHelper

  before_update :clear_exercise_translations

  translates :title, :short_title, :description

  has_many :assignments, :as => :assignable, dependent: :destroy
  has_many :exercise_illustrations, dependent: :destroy
  has_many :exercise_images, dependent: :destroy
  belongs_to :api_license
  belongs_to :owner, :class_name => "User"
  belongs_to :context, :polymorphic=>true

  attr_accessible :title, :short_title, :description, :exercise_illustrations, :exercise_images,
                  :context_id, :context_type, :code
  attr_protected :owner, :api_license_id


  validates :title, :short_title, :api_license, :owner, :code, :description, :presence => true
  validates :title, :code, :uniqueness => { :scope => :api_license_id }

  attr_accessible :translations_attributes, :exercise_illustrations_attributes, :exercise_images_attributes
  accepts_nested_attributes_for :translations, :exercise_illustrations, :exercise_images

  def as_json(options={})
    aux = super(options).except(:title, :short_title, :description)
    aux[:translations] = self.translations.as_json(except:[:id,:exercise_id,:created_at,:updated_at])
    aux[:translated_locales] = self.translated_locales
    aux
  end

  class Translation
    belongs_to :exercise
  end

  private

    def clear_exercise_translations
      self.translations.clear
    end

end