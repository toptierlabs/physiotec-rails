# == Schema Information
#
# Table name: sections
#
#  id               :integer          not null, primary key
#  category_id      :integer          not null
#  section_datum_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Section < ActiveRecord::Base

  belongs_to :category,          inverse_of: :sections
  belongs_to :section_datum

  has_many   :subsections,       dependent: :destroy

  has_many   :subsection_data,   through: :subsections

  attr_accessible :subsection_datum_ids,
                  :section_datum_id,
                  :category_id,
                  :name
        

  delegate   :name,
             :translations,    to: :section_datum

  validates  :category,        presence: true
  validates  :section_datum,   presence: true

  def module
    category
  end

end
