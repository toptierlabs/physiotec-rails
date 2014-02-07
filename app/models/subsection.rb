# == Schema Information
#
# Table name: subsections
#
#  id                  :integer          not null, primary key
#  section_id          :integer          not null
#  subsection_datum_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Subsection < ActiveRecord::Base

  belongs_to :section
  belongs_to :subsection_datum

  has_many   :subsection_exercises
  has_many   :exercises, through: :subsection_exercises

  delegate   :name,
             :translations, to: :subsection_datum

  attr_accessible :subsection_datum_id

  validates :section_id,        presence: true
  validates :subsection_datum,  presence: true

  validate :relation_with_section

  private

  def relation_with_section
  	unless subsection_datum.section_datum == section.section_datum
  		errors.add(:section, "invalid for the current subsectium_datum")
  		#false
  	end
  end

end
