class Section < ActiveRecord::Base

  belongs_to :category,          inverse_of: :sections
  belongs_to :section_datum

  has_many   :subsections,       dependent: :destroy

  has_many   :subsection_data,   through: :subsections

  attr_accessible :subsection_datum_ids,
                  :section_datum_id,
                  :category_id
        

  delegate   :name, :to => :section_datum

  validates  :category,        presence: true
  validates  :section_datum,   presence: true

  def as_json(options={})
    aux = super(options).except(:title, :short_title, :description)
    aux[:translations] = self.translations.as_json(except:[:exercise_id,:created_at,:updated_at])
    aux[:translated_locales] = self.translated_locales
    aux
  end

end
