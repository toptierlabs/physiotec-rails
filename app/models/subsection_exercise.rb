class SubsectionExercise < ActiveRecord::Base

  belongs_to :subsection
  belongs_to :exercise

  attr_accessible :subsection_id,
                  :exercise_id

  validates       :exercise_id,   uniqueness: { scope: :subsection_id }

  validates       :subsection,
                  :exercise,   presence: true

end
