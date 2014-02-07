class Scope
  @@scopes = []

	include Comparable

  def name
    @name
  end

  def id
  	@id.to_i
  end

  def <=> value
    @id <=> value.id
  end

  def self.all
    @@scopes
  end

  def self.find_by_id(value)
    @@scopes[value]
  end


  private

    def initialize(params = {})
      @id = params[:scope_id]
      @name = TYPES.keys[@id]
    end

    TYPES = { own: 0, clinic: 1, license: 2, api_license: 3 }

    TYPES.each do |k, v|
      #for each scope creates a new method for finding abilities with the given scope
      define_singleton_method("#{k}_user_abilities".as_sym) {
        UserAbility.where(scope: v)
      }

      define_singleton_method("#{k}_profile_abilities".as_sym) {
        ProfileAbility.where(scope: v)
      }

      define_singleton_method("#{k}_scope") { 
        @@scopes[v]
      }

      define_method("is_#{k}?") { 
        @id == v
      }

      #for each action creates a new method for getting the scope id
      define_singleton_method("#{k}_scope_id".as_sym) { v }

      @@scopes << self.new(scope_id: v)
    end

end
