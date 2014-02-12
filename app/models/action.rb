class Action < ActiveHash::Base

  require 'insensitive_hash'
  include ActiveHash::Associations

  self.data = [
    { :id => 1, :name => "create" }.insensitive,
    { :id => 2, :name => "show" }.insensitive,
    { :id => 3, :name => "update" }.insensitive,
    { :id => 4, :name => "destroy" }.insensitive,
    { :id => 5, :name => "translate" }.insensitive,
    { :id => 6, :name => "assign" }.insensitive,
    { :id => 7, :name => "unassign" }.insensitive
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