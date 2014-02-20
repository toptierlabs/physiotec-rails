class Action < ActiveHash::Base

  include ActiveHash::Associations

  self.data = [
    { id: 1, name: "Create", locale: nil },
    { id: 2, name: "Show", locale: nil },
    { id: 3, name: "Update", locale: nil },
    { id: 4, name: "Destroy", locale: nil },
    { id: 6, name: "Assign", locale: nil },
    { id: 7, name: "Unassign", locale: nil }
  ]

  has_many :user_abilities
  has_many :profile_abilities

  def self.create_by_language(value)
    method_name = "translate_to_#{value.description.parameterize.underscore}_action".to_sym
    unless Action.respond_to? method_name
      a = Action.create!(name: "Translate To #{value.description.titleize}", locale: value.locale.to_sym)
      define_singleton_method(method_name) { 
          find(a.id)
      }
    end
  end

  def is_translate?
    self.name.start_with? "Translate To"
  end
  

  def self.where(options)
    return @records if options.nil?
    (@records || []).select do |record|
      options.all? do |col, match|
        if match.is_a? Array
          match.include? record[col]
        else
          record[col] == match
        end
      end
    end
  end

  def self.scoped(options = nil)
    self
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


    Language.select("description, locale").each do |v|
      Action.create_by_language(v)
    end

end