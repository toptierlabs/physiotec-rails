class Action
  @@actions = []

  attr_reader :name, :id 


  def self.all
    @@actions
  end

  def self.find(params)
    _id = params.to_i
    if TYPES.values.include? _id
      @@actions[(params.to_i - 1)]
    else
      nil
    end
  end

  def self.find_by(params = {})
    #sanitize the params
    _id = params[:id].to_i if params[:id].present? 
    _name = params[:name].to_sym if params[:name].present?

    if _id.present? && _name.present?
      return nil unless TYPES[_name] == _id
    end

    if _id.present?
      self.find(_id)
    elsif _name.present?
      self.find(TYPES[_name])
    end
  end

  private

    def initialize(params = {})
      @id = params[:action_id]
      @name = TYPES.keys[@id-1]
    end

    TYPES = { create: 1, show: 2, update: 3, destroy: 4, translate: 5 }

    TYPES.each do |k, v|
      #for each action creates a new method for finding abilities with the given action
      define_singleton_method("#{k}_abilities".as_sym) {
        Ability.where(action: v)
      }

      define_singleton_method("#{k}_action") { 
        Action.new action_id: v
      }

      #for each action creates a new method for getting the action id
      define_singleton_method("#{k}_action_id".as_sym) { v }

      define_method("is_#{k}?") { 
        @id == v
      }

      @@actions << self.new(action_id: v)

    end

end
