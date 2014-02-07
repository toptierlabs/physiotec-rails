# == Schema Information
#
# Table name: subsection_exercises
#
#  id            :integer          not null, primary key
#  subsection_id :integer
#  exercise_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class SubsectionExercise < ActiveRecord::Base

  belongs_to :subsection
  belongs_to :exercise

  attr_accessible :subsection_id,
                  :exercise_id

  validates       :exercise_id,   uniqueness: { scope: :subsection_id }

  validates       :subsection,
                  :exercise,   presence: true

end
