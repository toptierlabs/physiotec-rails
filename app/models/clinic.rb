class Clinic < ActiveRecord::Base

  belongs_to :license
  attr_accessible :name, :license_id

  #multiple associations with exercises
  has_many :exercises, as: :context

  def clinic
  	self
  end

end