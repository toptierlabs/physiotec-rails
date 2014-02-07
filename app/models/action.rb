class Action
  @@actions = []

  def name
    @name
  end

  def id
    @id
  end

  def self.all
    @@actions
  end

  def self.find_by_id(value)
    @@actions[value]
  end

  def self.find_by_name(value)
    @@actions[TYPES[value]]
  end

  private

    def initialize(params = {})
      @id = params[:action_id]
      @name = TYPES.keys[@id]
    end

    TYPES = { create: 0, show: 1, update: 2, destroy: 3, translate: 4 }

    TYPES.each do |k, v|
      #for each action creates a new method for finding abilities with the given action
      define_singleton_method("#{k}_abilities".as_sym) {
        Ability.where(:action=> v)
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
