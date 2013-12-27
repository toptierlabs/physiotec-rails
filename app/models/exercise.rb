class Exercise < ActiveRecord::Base
	
  include AssignableHelper

  translates :title, :short_title, :description

  has_many :assignments, :as => :assignable, dependent: :destroy
  has_many :exercise_illustrations, dependent: :destroy
  has_many :exercise_images, dependent: :destroy
  belongs_to :api_license
  belongs_to :owner, :class_name => "User"
  belongs_to :context, :polymorphic=>true

  attr_accessible :title, :short_title, :description, :exercise_illustrations, :exercise_images
  attr_protected :owner, :api_license_id, :code


  validates :title, :short_title, :api_license, :owner, :code, :presence => true
  validates :title, :uniqueness => { :scope => :api_license_id }
  validates :code, :uniqueness => { :scope => :api_license_id }

  def as_json(options={})
    aux = super(options)
    aux[:translations] = self.translations.as_json(except:[:id,:exercise_id,:created_at,:updated_at])
    aux[:translated_locales] = self.translated_locales
    aux
  end

  def translations=(val)
    if val.first.class == Translation.class
      super(val)
    else
      formatted_values = val.map{ |v| Translation.new(v) }
      super(formatted_values)
    end
  end

  def exercise_illustrations=(val)
    if val.first.class == ExerciseIllustration.class
      super(val)
    else
      formatted_values = val.map{ |v| ExerciseIllustration.new(v.slice(:exercise_id), exercise: self) }
      super(formatted_values)
    end
  end

  def exercise_images=(val)
    if val.first.class == ExerciseImage.class
      super(val)
    else
      formatted_values = val.map{ |v| ExerciseImage.new(v.slice(:exercise_id), exercise: self) }
      super(formatted_values)
    end
  end

end