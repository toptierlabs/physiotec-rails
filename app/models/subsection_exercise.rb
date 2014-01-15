class SubsectionExercise < ActiveRecord::Base

  belongs_to :subsection
  belongs_to :exercise

  attr_accessible :subsection_id,
                  :exercise_id

  validates       :exercise_id,   uniqueness: { scope: :subseciton_id }

  validates       :subsection_id,
                  :exercise_id,   presence: true

end
