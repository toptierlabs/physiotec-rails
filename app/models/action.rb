class Action < ActiveHash::Base

  include ActiveHash::Associations

  self.data = [
    { id: 1, name: "Create" },
    { id: 2, name: "Show" },
    { id: 3, name: "Update" },
    { id: 4, name: "Destroy" },
    { id: 5, name: "Translate" },
    { id: 6, name: "Assign" },
    { id: 7, name: "Unassign" }
  ]

  has_many :user_abilities
  has_many :profile_abilities  

  def self.create_by_language_name(value)
    Action.create!(name: "Translate To #{value.titleize}")
  end

  def is_translate?
    self.name.start_with? "Translate To"
  end

  private

    self.data.each do |v|

      define_singleton_method("#{v[:name].underscore}_action") { 
        find(v[:id])
      }

      define_method("is_#{v[:name].underscore}?") { 
        self == self.class.find(v[:id])
      }
    end


    Language.pluck(:description).each do |v|
      Action.create_by_language_name(v)
    end

end