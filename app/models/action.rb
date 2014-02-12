class Action < ActiveHash::Base

  include ActiveHash::Associations

  self.data = [
    { :id => 1, :name => "Create" },
    { :id => 2, :name => "Show" },
    { :id => 3, :name => "Update" },
    { :id => 4, :name => "Destroy" },
    { :id => 5, :name => "Translate" },
    { :id => 6, :name => "Assign" },
    { :id => 7, :name => "Unassign" }
  ]

  has_many :user_abilities
  has_many :profile_abilities  

  private

    self.data.each do |v|

      define_singleton_method("#{v[:name].underscore}_action") { 
        find(v[:id])
      }

      define_method("is_#{v[:name].underscore}?") { 
        self == self.class.find(v[:id])
      }
    end

end