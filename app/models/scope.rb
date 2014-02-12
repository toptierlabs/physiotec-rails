class Scope < ActiveHash::Base

  include ActiveHash::Associations
  include Comparable

  self.data = [
    {:id => 1, :name => "User"},
    {:id => 2, :name => "Clinic"},
    {:id => 3, :name => "License"},
    {:id => 4, :name => "ApiLicense"},
  ]

  has_many :user_abilities
  has_many :profile_abilities  

  def <=> value
    id <=> value.id
  end

  private

    self.data.each do |v|

      define_singleton_method("#{v[:name].underscore}_scope") { 
        find(v[:id])
      }

      define_method("is_#{v[:name].underscore}?") { 
        self == self.class.find(v[:id])
      }

    end

end