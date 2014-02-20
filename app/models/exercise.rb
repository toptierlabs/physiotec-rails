class Exercise < ActiveRecord::Base
  belongs_to :subsection
  belongs_to :exercise_medium

  translates  :keywords,
              :description,
              :title,
              :short_title

  globalize_accessors

  attr_accessible :subsection_id,
                  :exercise_medium_id

  validates       :exercise_medium_id,  uniqueness: { scope: :subsection_id }

  validates       :subsection,
                  :exercise_medium,     presence: true

  private

    class Translation
      # Extend Translation class to make it able to store an Array
      serialize :keywords, Array
    end

end
