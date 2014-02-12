class Scope < ActiveHash::Base

  require 'insensitive_hash'

  include ActiveHash::Associations
  include Comparable

  self.data = [
    {:id => 1, :name => "User"}.insensitive,
    {:id => 2, :name => "Clinic"}.insensitive,
    {:id => 3, :name => "License"}.insensitive,
    {:id => 4, :name => "ApiLicense"}.insensitive
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